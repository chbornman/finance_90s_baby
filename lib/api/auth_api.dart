import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:finance_90s_baby/log_service.dart';

class AuthAPI {
  final Account account;

  AuthAPI(Client client) : account = Account(client);

  /// Registers a new user with email and password
  Future<models.User?> registerUser(String email, String password) async {
    try {
      return await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );
    } catch (e) {
      LogService.instance.error("Registration Error: $e");
      return null;
    }
  }

  /// Logs in a user with email and password
  Future<models.Session?> loginUser(String email, String password) async {
    try {
      final session = await account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      LogService.instance
          .info("Login successful, session created: ${session.$id}");
      return session;
    } catch (e) {
      LogService.instance.error("Login Error: $e");
      return null;
    }
  }

  /// Logs out the current user
  Future<void> logoutUser() async {
    try {
      await account.deleteSession(sessionId: 'current');
    } catch (e) {
      LogService.instance.error("Logout Error: $e");
    }
  }

  /// Retrieves the currently logged-in user
  Future<models.User?> getCurrentUser() async {
    try {
      return await account.get();
    } catch (e) {
      LogService.instance.error("Get Current User Error: $e");
      return null;
    }
  }
}
