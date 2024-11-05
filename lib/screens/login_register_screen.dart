import 'package:finance_90s_baby/log_service.dart';
import 'package:flutter/material.dart';
import '../api/auth_api.dart';

class LoginRegisterScreen extends StatefulWidget {
  final AuthAPI authAPI;
  final VoidCallback onLoginSuccess; // Callback for successful login

  const LoginRegisterScreen(this.authAPI,
      {Key? key, required this.onLoginSuccess})
      : super(key: key);

  @override
  _LoginRegisterScreenState createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoginMode = true; // Toggle between login and register mode

  void _toggleMode() {
    setState(() {
      isLoginMode = !isLoginMode;
    });
  }

  Future<void> _submit() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (isLoginMode) {
      // Attempt login
      final session = await widget.authAPI.loginUser(email, password);
      if (session != null) {
        widget.onLoginSuccess(); // Notify the parent widget on successful login
        LogService.instance.error("Login successful!");
      } else {
        LogService.instance.error("Login failed.");
      }
    } else {
      // Attempt registration
      final user = await widget.authAPI.registerUser(email, password);
      if (user != null) {
        LogService.instance.error("Registration successful!");
        setState(() {
          isLoginMode =
              true; // Switch to login mode after successful registration
        });
      } else {
        LogService.instance.error("Registration failed.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isLoginMode ? 'Login' : 'Register',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(isLoginMode ? 'Login' : 'Register'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _toggleMode,
                  child: Text(
                    isLoginMode
                        ? "Don't have an account? Register"
                        : "Already have an account? Login",
                    style: const TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
