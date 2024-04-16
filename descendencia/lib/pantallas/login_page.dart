import 'package:descendencia/pantallas/InicioPage.dart';
import 'package:descendencia/routes.dart';
import 'package:flutter/material.dart';
import 'package:descendencia/Widgets/InputItem.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({required key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/barra.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.all(80.0)),
              InputItem(
                  controller: emailController,
                  labelText: 'Email',
                  hintText: 'email',
                  icon: const Icon(
                    Icons.email,
                    color: Color.fromARGB(255, 42, 157, 0),
                  )),
              const SizedBox(height: 20.0),
              InputItem(
                controller: passwordController,
                labelText: 'Password',
                hintText: 'password',
                obscureText: obscureText,
                icon: const Icon(
                  Icons.lock,
                  color: Color.fromARGB(255, 42, 157, 0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                      color: Color.fromARGB(255, 42, 157, 0),
                      obscureText ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                ),
              ),
              const SizedBox(height: 80.0),
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
                        backgroundColor: Color.fromARGB(255, 0, 91, 26),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  backgroundColor: const Color.fromARGB(255, 0, 136, 7),
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
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, MyRoutes.register.name);
                },
                style: ElevatedButton.styleFrom(),
                child: const Text(
                  'Registrarse',
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 136, 7)), // Color del texto
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
