import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:finance_90s_baby/log_service.dart';

class AuthAPI {
  final Account account;

  AuthAPI(Client client) : account = Account(client);

  Future<void> createUser(String email, String password) async {
    // TODO lear about how apparently assigning to a variable forces the await to wait for the result
    final user = await account.create(
        userId: ID.unique(), email: email, password: password);

    // Set default role as "user" in preferences
    await account.updatePrefs(prefs: {'role': 'user'});
  }

  Future<String?> getUserRole() async {
    final user = await account.get();
    return user.prefs.data['role'] as String?;
  }

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
