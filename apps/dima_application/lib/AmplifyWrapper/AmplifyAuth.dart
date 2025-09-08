import 'package:amplify_flutter/amplify_flutter.dart';

class AmplifyAuth {
  // Define your Auth methods here

  Future<AuthSession> fetchAuthSession() async {
    return Amplify.Auth.fetchAuthSession();
  }

  Future<AuthUser> getCurrentUser() async {
    return Amplify.Auth.getCurrentUser();
  }

  Future<List<AuthUserAttribute>> fetchUserAttributes() async {
    return Amplify.Auth.fetchUserAttributes();
  }

  Future<void> updateUserAttributes(List<AuthUserAttribute> attributes) async {
    await Amplify.Auth.updateUserAttributes(
      attributes: attributes,
    );
  }

  Future<void> signIn(String email, String password) async {
    await Amplify.Auth.signIn(
      username: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await Amplify.Auth.signOut();
  }

  Future<void> signUp(String email, String password) async {
    await Amplify.Auth.signUp(
      username: email,
      password: password,
    );
  }

  Future<void> deleteUser() async {
    await Amplify.Auth.deleteUser();
  }

  Future<void> updatePassword(String oldPassword, String newPassword) async {
    await Amplify.Auth.updatePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }

  void listen(void Function(AuthHubEvent) handleAuthEvent) {
    Amplify.Hub.listen(HubChannel.Auth, handleAuthEvent);
  }
}
