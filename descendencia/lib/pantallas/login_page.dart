import 'package:descendencia/pantallas/InicioPage.dart';
import 'package:descendencia/routes.dart';
import 'package:flutter/material.dart';
import 'package:descendencia/Widgets/InputItem.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        backgroundColor: Color.fromARGB(255, 0, 216, 137),
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 200,
                width: 200,
                child: Image.asset('assets/logo.jpg'),
              ),
              const Padding(padding: EdgeInsets.all(80)),
              InputItem(
                  controller: emailController,
                  labelText: 'Email',
                  hintText: 'email',
                  icon: const Icon(
                    Icons.email,
                    color: Color.fromARGB(255, 156, 255, 137),
                  )),
              const SizedBox(height: 20.0),
              InputItem(
                controller: passwordController,
                labelText: 'Password',
                hintText: 'password',
                obscureText: obscureText,
                icon: const Icon(
                  Icons.lock,
                  color: Color.fromARGB(255, 156, 255, 137),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                      obscureText ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    // Cambia el estado de la contraseña
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (emailController.text == 'joseph.alcerro@unah.hn' &&
                      passwordController.text == '20222000391') {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => InicioPage()));
                    return;
                  } else {
                    // Si las credenciales son incorrectas, muestra un mensaje de error
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Credenciales incorrectas'),
                        backgroundColor: Color.fromARGB(255, 156, 255, 137),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  backgroundColor: Color.fromARGB(255, 0, 136, 7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(
                          255, 255, 255, 255)), // Tamaño del texto
                ),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
      drawerScrimColor: const Color.fromARGB(255, 156, 255, 137),
    );
  }
}
