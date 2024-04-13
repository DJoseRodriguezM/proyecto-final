import 'dart:js';
import 'package:descendencia/pantallas/login_page.dart';
import 'package:descendencia/routes.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  MyRoutes.loginroute.name: (context) => const LoginPage()
};