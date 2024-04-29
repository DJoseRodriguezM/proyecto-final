import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:descendencia/pantallas/login_page.dart';
// Pendiente Permisos Notificaciones
// import 'package:descendencia/pantallas/notificaciones_page.dart';

class AjustesPage extends StatelessWidget {
  const AjustesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 5, 93, 24),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            ListTile(
              title: Text('Nombre'),
              subtitle: Text(user?.displayName ?? 'Nombre no disponible'),
              leading: const Icon(Icons.person),
            ),
            ListTile(
              title: const Text('Correo Electrónico'),
              subtitle: Text(user?.email ?? 'Correo no disponible'),
              leading: const Icon(Icons.email),
            ),
            const Divider(),
            ListTile(
              title: const Text('Notificaciones'),
              leading: const Icon(Icons.notifications),
              onTap: () {
                // PENDIENTE NAVEGACION DE PERMISOS DE NOTIFICACION
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Ver Permisos'),
              leading: const Icon(Icons.security),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Permisos Requeridos'),
                      content: const Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('1. Cámara'),
                          Text('2. Internet'),
                          Text('3. Almacenamiento'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Aceptar'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Sobre Nosotros'),
              leading: const Icon(Icons.info),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              title: const Text('Cerrar Sesión'),
              leading: const Icon(Icons.logout),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
