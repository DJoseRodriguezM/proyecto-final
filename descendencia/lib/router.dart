import 'package:descendencia/pantallas/InicioPage.dart';
import 'package:descendencia/pantallas/login_page.dart';
import 'package:descendencia/pantallas/register_page.dart';
import 'package:descendencia/routes.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  MyRoutes.loginroute.name: (context) => const LoginPage(key: Key('LoginPageState')),
  MyRoutes.Inicioroute.name: (context) => InicioPage(),
  MyRoutes.register.name: (context) => const RegisterPage(key: Key('RegisterPageState')),
};
