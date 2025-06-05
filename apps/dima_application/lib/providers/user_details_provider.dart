import 'package:flutter_riverpod/flutter_riverpod.dart';
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

// Provider for the user details state
final userDetailsProvider = StateNotifierProvider<UserDetailsNotifier, AsyncValue<UserDetails?>>((ref) {
  return UserDetailsNotifier(ref);
});

// Notifier class to manage user details state
class UserDetailsNotifier extends StateNotifier<AsyncValue<UserDetails?>> {
  final Ref ref;

  UserDetailsNotifier(this.ref) : super(const AsyncValue.loading()) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final userId = await ref.read(userIdProvider.future);
      if (userId != null) {
        await loadUserDetails(userId);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> loadUserDetails(String userId) async {
    state = const AsyncValue.loading();
    try {
      final service = await ref.read(userDetailsServiceProvider);
      final details = await service.getUserDetails(userId);
      state = AsyncValue.data(details);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateUserDetails(UserDetails updatedDetails) async {
    try {
      final service = await ref.read(userDetailsServiceProvider);
      final result = await service.updateUserDetails(updatedDetails);
      if (result != null) {
        state = AsyncValue.data(result);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> clearCache(String userId) async {
    try {
      final service = await ref.read(userDetailsServiceProvider);
      await service.clearCache(userId);
      await loadUserDetails(userId); // Reload details after clearing cache
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> signOut(String userId) async {
    try {
      final service = await ref.read(userDetailsServiceProvider);
      await service.signOut(userId);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    try {
      final service = await ref.read(userDetailsServiceProvider);
      return await service.changePassword(oldPassword, newPassword);
    } catch (error) {
      return false;
    }
  }

  Future<bool> deleteAccount(String userId) async {
    try {
      final service = await ref.read(userDetailsServiceProvider);
      final success = await service.deleteAccount(userId);
      if (success) {
        state = const AsyncValue.data(null);
      }
      return success;
    } catch (error) {
      return false;
    }
  }
} 