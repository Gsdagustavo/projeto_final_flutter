import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const String routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController(text: 'test@gmail.com');
  final _passwordController = TextEditingController(text: 'test123');

  bool _obscurePassword = true;

  String? _emailValidator(String? email) {
    if (email == null || email.isEmpty || !email.contains('@')) {
      return 'Invalid Email';
    }

    return null;
  }

  String? _passwordValidator(String? password) {
    if (password == null || password.isEmpty) {
      return 'Invalid Password';
    }

    return null;
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text;
    final password = _passwordController.text;

    final loginProvider = Provider.of<UserProvider>(context, listen: false);
    await loginProvider.signinWithEmailAndPassword(
      email: email,

      password: password,
    );

    if (loginProvider.hasError) {
      unawaited(
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Warning'),
            content: Text(loginProvider.errorMsg),
          ),
        ),
      );

      return;
    }

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Login'),
        content: Text('Logged in successfully!'),
      ),
    );

    unawaited(Navigator.pushReplacementNamed(context, HomePage.routeName));
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Login',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),

            Padding(padding: EdgeInsets.all(86)),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: _emailValidator,
                    controller: _emailController,
                    onTapUpOutside: (_) => FocusScope.of(context).unfocus(),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),

                  Padding(padding: EdgeInsets.all(18)),

                  TextFormField(
                    validator: _passwordValidator,
                    controller: _passwordController,
                    onTapUpOutside: (_) => FocusScope.of(context).unfocus(),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: _togglePasswordVisibility,
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),

                    obscureText: _obscurePassword,
                  ),
                ],
              ),
            ),

            Padding(padding: EdgeInsets.all(16)),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _login,
                    child: Text('Login'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),

                Padding(padding: EdgeInsetsGeometry.all(16)),

                TextButton(
                  onPressed: () {},
                  child: Text('Forgot your password?'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
