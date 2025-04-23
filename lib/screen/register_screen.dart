import 'package:billiard_club_frontend/service/authentication_service.dart';
import 'package:flutter/material.dart';
import '../model/request/user_register_request.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthenticationService apiService = AuthenticationService();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String username = '';
  String firstname = '';
  String lastname = '';
  String password = '';

  void register(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      UserRegisterRequest request = UserRegisterRequest(
        username: username,
        firstname: firstname,
        lastname: lastname,
        password: password,
      );

      apiService.register(request, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация', style: TextStyle(color: Colors.black)),
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
                        labelText: 'Имя',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (value) => firstname = value,
                      validator: (value) =>
                          value!.isEmpty ? 'Введите имя' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Фамилия',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (value) => lastname = value,
                      validator: (value) =>
                          value!.isEmpty ? 'Введите фамилию' : null,
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
                    ElevatedButton(
                      onPressed: () => register(context),
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),),
                      child: const Text('Зарегистрироваться',style: TextStyle(fontFamily: 'Courier New'),),
                    ),
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