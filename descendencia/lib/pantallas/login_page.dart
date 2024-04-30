import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:descendencia/pantallas/components/general_page.dart';
import 'package:descendencia/pantallas/register_page.dart';
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
// * * * * * * * * * * * * *  * * * * * *  * * * * * * *
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/barra.png'),
                  fit: BoxFit.fill,
                ),
              ),
              height: 200,
            ),
// * * * * * * * * * * * * *  * * * * * *  * * * * * * *
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InputItem(
                    controller: emailController,
                    labelText: 'Email',
                    hintText: 'email',
                    icon: const Icon(
                      Icons.email,
                      color: Color.fromARGB(255, 5, 93, 24),
                    ),
                  ),
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
                        obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 80.0),
                  ElevatedButton(
                    onPressed: () async {
                      final FirebaseFirestore firestore = FirebaseFirestore.instance;
                      final String email = emailController.text.trim();
                      final String password = passwordController.text.trim();

                      try {
                        // Consultar la colección 'usuarios' en Firestore para el email y contraseña dada
                        final QuerySnapshot<Map<String, dynamic>> userDoc= await firestore
                            .collection('usuarios')
                            .where('email', isEqualTo: email)
                            .where('contraseña', isEqualTo: password)
                            .limit(1)
                            .get();

                        // Verificar si se encontró un usuario con la documentación dada
                        if (userDoc.docs.isNotEmpty) {
                            Navigator.pushReplacementNamed(
                              context,
                              MyRoutes.inicioroute.name,
                            );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('No se encontró un usuario con ese correo electrónico.'),
                              backgroundColor: Color.fromARGB(255, 5, 93, 24),
                            ),
                          );
                        }
                      } catch (e) {
                        print('Error: $e');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 50,
                      ),
                      backgroundColor: const Color.fromARGB(255, 5, 93, 24),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                  // *********************************************************************
                  const SizedBox(height: 40.0),
                  ElevatedButton(
                    onPressed: () async {
                      final emailId = emailController.text;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: const Text(
                      'Registrarse',
                      style: TextStyle(
                        color: Color.fromARGB(255, 5, 93, 24),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      final emailId = emailController.text;
                      signInWithGoogle()
                          .then((UserCredential user) => {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return GeneralPage(emailId: emailId);
                                    },
                                  ),
                                ),
                              })
                          .catchError(
                        (error) {
                          return <Future<dynamic>>{Future.error(error)};
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        )),
                    child: const Text(
                      'Usar Google',
                      style: TextStyle(color: Color.fromARGB(255, 5, 93, 24)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
