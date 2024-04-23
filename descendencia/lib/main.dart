import 'package:descendencia/firebase_options.dart';
import 'package:descendencia/pantallas/InicioPage.dart';
import 'package:descendencia/pantallas/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:descendencia/routes.dart';
import 'package:descendencia/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              print('Error en la autenticación: ${snapshot.error}');
              return const LoginPage();
            }
            if (snapshot.hasData) {
              return InicioPage();
            }
            return const LoginPage();
          },
        ),
        //initialRoute: MyRoutes.loginroute.name,
        routes: routes,
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => PageNotfound(name: settings.name),
          );
        });
  }
}

class PageNotfound extends StatelessWidget {
  const PageNotfound({super.key, required this.name});

  final String? name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('La ruta $name no existe'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(
                    context, MyRoutes.loginroute.name);
              },
              child: const Text('Ir a la página principal'),
            ),
          ],
        ),
      ),
    );
  }
}
