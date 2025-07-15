import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  static const String routeName = '/register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  String? _passwordValidator(String? password) {
    if (password == null || password.isEmpty) {
      return 'Invalid Password';
    }

    if (password.length <= 3) {
      return 'Password too short';
    }

    return null;
  }

  String? _emailValidator(String? email) {
    if (email == null || email.isEmpty) {
      return 'Invalid Email';
    }

    return null;
  }

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text;
    final password = _passwordController.text;

    final loginProvider = Provider.of<UserProvider>(context, listen: false);
    await loginProvider.createUserWithEmailAndPassword(
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
        title: Text('Register'),
        content: Text('Your account was registered successfully!'),
      ),
    );

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('No'),
          ),

          ElevatedButton(
            onPressed: () {
              unawaited(
                Navigator.pushReplacementNamed(context, HomePage.routeName),
              );
            },
            child: Text('Yes'),
          ),
        ],

        actionsAlignment: MainAxisAlignment.spaceBetween,

        title: Text('Login'),
        content: Text('Would you want to login?'),
      ),
    );
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
              'Register',
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
                    onPressed: _register,
                    child: Text('Register'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
