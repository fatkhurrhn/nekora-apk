import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import 'main_navigation.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _auth = AuthService();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _handleRegister() async {
    if (_fullNameController.text.trim().isEmpty) {
      _showSnackbar('Nama lengkap harus diisi');
      return;
    }
    if (_usernameController.text.trim().isEmpty) {
      _showSnackbar('Username harus diisi');
      return;
    }
    if (_emailController.text.trim().isEmpty) {
      _showSnackbar('Email harus diisi');
      return;
    }
    if (_passwordController.text.isEmpty) {
      _showSnackbar('Password harus diisi');
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      _showSnackbar('Password tidak cocok');
      return;
    }
    if (_passwordController.text.length < 6) {
      _showSnackbar('Password minimal 6 karakter');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _auth.registerWithEmailPassword(
        fullName: _fullNameController.text.trim(),
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigation()),
        );
      }
    } catch (e) {
      _showSnackbar(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackbar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 12)),
        backgroundColor:
            isError ? const Color(0xFFEF4444) : const Color(0xFF22C55E),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          Container(
            height: 300,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Color.fromRGBO(255, 255, 255, 0.05),
                  Colors.transparent
                ],
                center: Alignment.topCenter,
                radius: 0.8,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                            color: const Color.fromRGBO(255, 255, 255, 0.08)),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.pets, size: 64, color: Colors.white),
                          const SizedBox(height: 16),
                          Text(
                            'NEKORA',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 4,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'create account',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 12,
                              color: const Color.fromRGBO(255, 255, 255, 0.45),
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 255, 255, 0.02),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: const Color.fromRGBO(255, 255, 255, 0.08)),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _fullNameController,
                          style: const TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 14,
                              color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'FULL NAME',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _usernameController,
                          style: const TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 14,
                              color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'USERNAME',
                            hintText: 'meow_cat',
                            prefixIcon: Icon(Icons.alternate_email),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _emailController,
                          style: const TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 14,
                              color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'EMAIL',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: const TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 14,
                              color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'PASSWORD',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          style: const TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 14,
                              color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'CONFIRM PASSWORD',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(_obscureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () => setState(() =>
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _handleRegister,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.black))
                              : Text('REGISTER',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1)),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            '← BACK TO LOGIN',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 12,
                              color: const Color.fromRGBO(255, 255, 255, 0.45),
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
