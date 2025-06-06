import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../generated/flutter-models/UserDetails.dart';
import '../services/user_details_service.dart';
import '../services/auth_service.dart';
import '../providers/isar_provider.dart';


// Provider for the UserDetailsService
final userDetailsServiceProvider = Provider<Future<UserDetailsService>>((ref) async {
  final isar = await ref.watch(isarProvider);
  return UserDetailsService(isar: isar);
});

// Provider for the current user ID
final userIdProvider = FutureProvider<String?>((ref) async {
  return AuthService.getCurrentUserId();
});

// Provider for the user details state. The String is a unique ID to force rebuilds.
final userDetailsProvider = StateNotifierProvider<UserDetailsNotifier, AsyncValue<(UserDetails?, String)>>((ref) {
  return UserDetailsNotifier(ref);
});

// Notifier class to manage user details state
class UserDetailsNotifier extends StateNotifier<AsyncValue<(UserDetails?, String)>> {
  final Ref ref;

  UserDetailsNotifier(this.ref) : super(const AsyncValue.loading()) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final userId = await ref.read(userIdProvider.future);
      if (userId != null) {
        await loadUserDetails(userId);
      } else {
        // If there's no user, we still need to resolve the state.
        state = AsyncValue.data((null, const Uuid().v4()));
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> loadUserDetails(String userId) async {
    final previousState = state;
    // Set state to loading, but `copyWithPrevious` will keep the old data and set isRefreshing to true.
    state = AsyncValue<(UserDetails?, String)>.loading().copyWithPrevious(previousState);

    try {
      final service = await ref.read(userDetailsServiceProvider);
      // Force a fresh fetch from the server
      await service.clearCache(userId);
      final details = await service.getUserDetails(userId);
      
      // On success, update the state with the new data and a unique ID.
      state = AsyncValue.data((details, const Uuid().v4()));
    } catch (error, stackTrace) {
      // On error, report the error but keep the previous data.
      state = AsyncValue<(UserDetails?, String)>.error(error, stackTrace).copyWithPrevious(previousState);
    }
  }

  Future<bool> updateUserDetails(UserDetails updatedDetails) async {
    final previousState = state;
    final previousTuple = previousState.value;
    if (previousTuple == null) {
      // Cannot update if there's no previous state to get the ID from.
      return false;
    }

    // Optimistically update the UI, but REUSE the existing unique ID to prevent rebuild.
    state = AsyncValue.data((updatedDetails, previousTuple.$2));

    try {
      final service = await ref.read(userDetailsServiceProvider);
      final result = await service.updateUserDetails(updatedDetails);

      if (result != null) {
        // The optimistic update was correct. We can now assign a new ID to mark a "clean" state.
        state = AsyncValue.data((result, const Uuid().v4()));
        return true;
      } else {
        // If update failed, revert to the previous state.
        state = previousState;
        return false;
      }
    } catch (error, stackTrace) {
      // If update failed, revert to previous state and show error
      state = AsyncValue<(UserDetails?, String)>.error(error, stackTrace).copyWithPrevious(previousState);
      return false;
    }
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    try {
      final service = await ref.read(userDetailsServiceProvider);
      return await service.changePassword(oldPassword, newPassword);
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteAccount(String userId) async {
    try {
      final service = await ref.read(userDetailsServiceProvider);
      final success = await service.deleteAccount(userId);
      if (success) {
        // After deletion, set state to no user.
        state = AsyncValue.data((null, const Uuid().v4()));
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  Future<void> signOut(String userId) async {
    final service = await ref.read(userDetailsServiceProvider);
    await service.signOut(userId);
    state = AsyncValue.data((null, const Uuid().v4()));
  }
} 