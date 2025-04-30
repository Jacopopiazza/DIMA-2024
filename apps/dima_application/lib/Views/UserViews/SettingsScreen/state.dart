// File: lib/models/user_details_state.dart (or similar location)
import 'package:dima_application/generated/flutter-models/UserDetails.dart'; // Adjust import path

sealed class UserDetailsState {}

class UserDetailsLoading extends UserDetailsState {}

class UserDetailsSuccess extends UserDetailsState {
  final UserDetails userDetails;
  final bool isStale; // True if data came from stale cache during fallback

  UserDetailsSuccess(this.userDetails, {this.isStale = false});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDetailsSuccess &&
          runtimeType == other.runtimeType &&
          userDetails == other.userDetails &&
          isStale == other.isStale;

  @override
  int get hashCode => userDetails.hashCode ^ isStale.hashCode;
}

// Specific state indicating the user exists but hasn't set up details yet
class UserDetailsNeedsSetup extends UserDetailsState {
   final String userId; // Provide userId for potential immediate use

   UserDetailsNeedsSetup(this.userId);

   @override
   bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDetailsNeedsSetup &&
          runtimeType == other.runtimeType &&
          userId == other.userId;

   @override
   int get hashCode => userId.hashCode;
}

class UserDetailsError extends UserDetailsState {
  final String message;
  final dynamic error; // Optional: keep original error for logging/debugging

  UserDetailsError(this.message, [this.error]);

   @override
   bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDetailsError &&
          runtimeType == other.runtimeType &&
          message == other.message;

   @override
   int get hashCode => message.hashCode;
}