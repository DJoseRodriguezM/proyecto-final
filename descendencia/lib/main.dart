import 'package:flutter/material.dart';
import 'package:descendencia/routes.dart';
import 'package:descendencia/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: MyRoutes.loginroute.name,
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
