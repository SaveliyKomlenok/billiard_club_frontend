import 'package:billiard_club_frontend/model/request/user_authenticate_request.dart';
import 'package:billiard_club_frontend/screen/home_screen.dart';
import 'package:billiard_club_frontend/screen/register_screen.dart';
import 'package:billiard_club_frontend/service/authentication_service.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthenticationService authService = AuthenticationService();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String username = '';
  String password = '';

  void login() async {
    if (formKey.currentState!.validate()) {
      try {
        UserAuthenticateRequest request = UserAuthenticateRequest(
          username: username,
          password: password,
        );
        authService.authenticate(request, context);
      } catch (e) {
        _showSnackbar('Неверный пароль или имя пользователя');
      }
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Авторизация', style: TextStyle(color: Colors.black)),
        backgroundColor: const Color.fromARGB(255, 110, 228, 114),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 175, 239, 169),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Имя пользователя',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (value) => username = value,
                      validator: (value) =>
                          value!.isEmpty ? 'Введите имя пользователя' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Пароль',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      obscureText: true,
                      onChanged: (value) => password = value,
                      validator: (value) =>
                          value!.isEmpty ? 'Введите пароль' : null,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // Aligns buttons to both ends
                      children: [
                        ElevatedButton(
                          onPressed: login,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Войти',
                            style: TextStyle(fontFamily: 'Courier New'),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Регистрация',
                            style: TextStyle(fontFamily: 'Courier New'),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
