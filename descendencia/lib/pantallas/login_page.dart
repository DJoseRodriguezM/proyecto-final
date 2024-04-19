import 'package:descendencia/pantallas/InicioPage.dart';
import 'package:descendencia/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:descendencia/Widgets/InputItem.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

class LoginPage extends StatefulWidget {
  const LoginPage({key}) : super(key: key);

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 200,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/barra.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.all(50.0)),
              InputItem(
                  controller: emailController,
                  labelText: 'Email',
                  hintText: 'email',
                  icon: const Icon(
                    Icons.email,
                    color: Color.fromARGB(255, 5, 93, 24),
                  )),
              const SizedBox(height: 20.0),
              InputItem(
                controller: passwordController,
                labelText: 'Password',
                hintText: 'password',
                obscureText: obscureText,
                icon: const Icon(
                  Icons.lock,
                  color: Color.fromARGB(255, 5, 93, 24),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                      color: const Color.fromARGB(255, 5, 93, 24),
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
                  if ((emailController.text == 'joseph.alcerro@unah.hn' &&
                      passwordController.text == '20222000391') || (emailController.text == 'dj.rodriguez@unah.hn' &&
                      passwordController.text == '20222000953')) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => InicioPage()));
                    return;
                  } else {
                    // Si las credenciales son incorrectas, muestra un mensaje de error
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Credenciales incorrectas'),
                        backgroundColor: Color.fromARGB(255, 5, 93, 24),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  backgroundColor: const Color.fromARGB(255, 5, 93, 24),
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
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Registrarse',
                  style: TextStyle(
                      color: Color.fromARGB(255, 5, 93, 24), // Color del texto
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  signInWithGoogle()
                  .then((UserCredential user) => {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) {
                              return InicioPage();
                            },
                          ),
                        ),
                      })
                  .catchError(
                    () {
                      print('Error');
                    },
                  );
                },
                child: const Text(
                  'Usar Google'
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
