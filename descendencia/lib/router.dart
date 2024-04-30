import 'package:descendencia/pantallas/login_page.dart';
import 'package:descendencia/pantallas/register_page.dart';
import 'package:descendencia/routes.dart';
import 'package:flutter/material.dart';
import 'package:descendencia/pantallas/components/almacenamiento_page.dart';
import 'package:descendencia/pantallas/components/personal_page.dart';
import 'package:descendencia/pantallas/components/screens/calendar_page.dart';


final Map<String, Widget Function(BuildContext)> routes = {
  MyRoutes.loginroute.name: (context) => const LoginPage(key: Key('LoginPageState')),
  MyRoutes.register.name: (context) => const RegisterPage(key: Key('RegisterPageState')),
  MyRoutes.almacenamiento.name: (context) => const AlmacenamientoPage(),
  MyRoutes.personal.name: (context) => const PersonalPage(),
  MyRoutes.calendar.name: (context) => const CalendarPage(),
};
