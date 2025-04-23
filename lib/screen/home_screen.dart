import 'package:billiard_club_frontend/model/request/user_change_password_request.dart';
import 'package:billiard_club_frontend/model/request/user_edit_request.dart';
import 'package:billiard_club_frontend/model/user_response.dart';
import 'package:billiard_club_frontend/screen/billiard_table_screen.dart';
import 'package:billiard_club_frontend/screen/cues_screen.dart';
import 'package:billiard_club_frontend/screen/login_screen.dart';
import 'package:billiard_club_frontend/screen/reservation_active.dart';
import 'package:billiard_club_frontend/screen/reservation_history.dart';
import 'package:billiard_club_frontend/screen/selected_items_screen.dart';
import 'package:billiard_club_frontend/screen/slider.dart';
import 'package:billiard_club_frontend/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 
  String? token;
  String? role;
  String? username;
  late SharedPreferences prefs;
  UserResponse? userResponse;

  @override
  void initState() {
    super.initState();
    initSharedPref();
    loadUser();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      role = prefs.getString('role');
      username = prefs.getString('username');
    });
  }

  void loadUser() async {
    UserResponse response = await UserService().getProfile();
    setState(() {
      userResponse = response;
    });
  }

  void _showChangePasswordDialog() {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();
    String? errorMessage;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Изменить пароль'),
          backgroundColor: Colors.white,
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: passwordController,
                    decoration:
                        const InputDecoration(labelText: 'Новый пароль'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введите пароль';
                      } else if (value.length < 6) {
                        return 'Пароль должен содержать минимум 6 символов.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: confirmPasswordController,
                    decoration:
                        const InputDecoration(labelText: 'Подтвердите пароль'),
                    obscureText: true,
                    validator: (value) {
                      if (value != passwordController.text) {
                        return 'Пароли не совпадают!';
                      }
                      return null;
                    },
                  ),
                  if (errorMessage != null) // Отображение сообщения об ошибке
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        errorMessage!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Закрыть диалог
              },
              child: const Text(
                'Отмена',
                style: TextStyle(color: Colors.red, fontFamily: 'Courier New'),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final password = passwordController.text;

                  final request = UserChangePasswordRequest(password: password);
                  try {
                    await UserService().changePassword(request);
                    Navigator.of(context).pop(); // Закрыть диалог
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: const Text('Пароль успешно изменён!')),
                    );
                  } catch (e) {
                    errorMessage = 'Ошибка изменения пароля: $e';
                    setState(
                        () {}); // Обновление состояния для отображения сообщения
                  }
                }
              },
              child: const Text(
                'Сохранить',
                style:
                    TextStyle(color: Colors.green, fontFamily: 'Courier New'),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEditProfileDialog() {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController firstnameController =
        TextEditingController(text: userResponse?.firstname);
    final TextEditingController lastnameController =
        TextEditingController(text: userResponse?.lastname);
    final TextEditingController usernameController =
        TextEditingController(text: userResponse?.username);
    String? errorMessage;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Изменить профиль'),
          backgroundColor: Colors.white,
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: firstnameController,
                    decoration: const InputDecoration(labelText: 'Имя'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введите имя.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: lastnameController,
                    decoration: const InputDecoration(labelText: 'Фамилия'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введите фамилию.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: usernameController,
                    decoration:
                        const InputDecoration(labelText: 'Имя пользователя'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введите имя пользователя.';
                      }
                      return null;
                    },
                  ),
                  if (errorMessage != null) // Отображение сообщения об ошибке
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Закрыть диалог
              },
              child: const Text('Отмена',
                  style:
                      TextStyle(color: Colors.red, fontFamily: 'Courier New')),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final firstname = firstnameController.text;
                  final lastname = lastnameController.text;
                  final username = usernameController.text;

                  final request = UserEditRequest(
                    firstname: firstname,
                    lastname: lastname,
                    username: username,
                  );

                  try {
                    await UserService().updateProfile(request);
                    Navigator.of(context).pop(); // Закрыть диалог
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Профиль успешно обновлён!')),
                    );
                    loadUser(); // Обновление информации о пользователе
                  } catch (e) {
                    errorMessage = 'Ошибка обновления профиля: $e';
                    setState(
                        () {}); // Обновление состояния для отображения сообщения
                  }
                }
              },
              child: const Text('Сохранить',
                  style: TextStyle(
                      color: Colors.green, fontFamily: 'Courier New')),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 110, 228, 114),
        title: const Text('Карамболь'),
        centerTitle: true,
        actions: [
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  if (role != null) {
                    Scaffold.of(context).openDrawer();
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),

      backgroundColor: Color.fromARGB(255, 175, 239, 169),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 5,),
            SimpleSlider(),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Выравнивание по центру
              children: [
                
                const SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CueScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green, // Цвет фона кнопки
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 32), // Отступы
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Скругление углов
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize
                        .min, // Занимает минимально необходимое пространство
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "lib/images/pool-cue-svgrepo-com.svg",
                        width: 35,
                        height: 35,
                        color: Colors.white, // Цвет иконки
                      ),
                      const SizedBox(
                          width: 10), // Отступ между иконкой и текстом
                      const Text('Кии', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
                const SizedBox(width: 20), // Отступ между кнопками
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BilliardTableScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green, // Цвет фона кнопки
                    padding: const EdgeInsets.symmetric(
                        vertical: 5, horizontal: 30), // Отступы
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Скругление углов
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize
                        .min, // Занимает минимально необходимое пространство
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "lib/images/pool-table-svgrepo-com.svg",
                        width: 50,
                        height: 50,
                        color: Colors.white, // Цвет иконки
                      ),
                      const SizedBox(
                          width: 10), // Отступ между иконкой и текстом
                      const Text('Столы', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (role != null)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SelectedScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.green,
                  backgroundColor: Colors.white, // Цвет фона кнопки
                  padding: const EdgeInsets.symmetric(
                      vertical: 5, horizontal: 20), // Отступы
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Скругление углов
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "lib/images/pool-table-svgrepo-com.svg",
                      width: 50,
                      height: 50,
                      color: Colors.green, // Цвет иконки
                    ),
                    const SizedBox(width: 10), // Отступ между иконкой и текстом
                    const Text(
                      'Выбранное оборудование',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
      drawer: Drawer(
        backgroundColor: Color.fromARGB(255, 152, 231, 145),
        width: MediaQuery.of(context).size.width * 0.7,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey,
                    child: Text(
                      userResponse?.username?.isNotEmpty == true
                          ? userResponse!.username[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${userResponse?.firstname}\n${userResponse?.lastname}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Профиль чемпиона',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _showChangePasswordDialog,
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(225, 50),
                  foregroundColor: Colors.green,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock, color: Colors.green),
                    const SizedBox(width: 10),
                    Text(
                      'Изменить пароль',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Courier New'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _showEditProfileDialog();
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(225, 50),
                  foregroundColor: Colors.green,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person, color: Colors.green),
                    const SizedBox(width: 10),
                    Text(
                      'Изменить профиль',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Courier New'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReservationsPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(225, 50),
                  foregroundColor: Colors.green,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, color: Colors.green),
                    const SizedBox(width: 10),
                    Text(
                      'История',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Courier New'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReservationsActivePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(225, 50),
                  foregroundColor: Colors.green,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bookmark, color: Colors.green),
                    const SizedBox(width: 10),
                    Text(
                      'Активные брони',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Courier New'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove('token');
                  prefs.remove('role');
                  prefs.remove('username');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(225, 50),
                  foregroundColor: Colors.red,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.exit_to_app, color: Colors.red),
                    const SizedBox(width: 10),
                    Text(
                      'Выйти',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Courier New'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      drawerScrimColor: Colors.black54, // Цвет затемнения
    );
  }
}
