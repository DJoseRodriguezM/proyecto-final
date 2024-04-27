import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:descendencia/pantallas/login_page.dart';
// Importa la pantalla de notificaciones
// import 'package:descendencia/pantallas/notificaciones_page.dart';

class AjustesPage extends StatelessWidget {
  const AjustesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtener el usuario actualmente autenticado
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
            // Información de la cuenta
            const SizedBox(height: 20),
            ListTile(
              title: Text('Nombre'),
              subtitle: Text(user?.displayName ?? 'Nombre no disponible'),
              leading: Icon(Icons.person),
            ),
            ListTile(
              title: Text('Correo Electrónico'),
              subtitle: Text(user?.email ?? 'Correo no disponible'),
              leading: Icon(Icons.email),
            ),
            // Separación
            const Divider(),
            // Botón para ir a la sección de notificaciones
            ListTile(
              title: const Text('Notificaciones'),
              leading: Icon(Icons.notifications),
              onTap: () {
                // Aquí puedes agregar la navegación a la pantalla de notificaciones
              },
            ),
            // Separación
            const Divider(),
            // Botón para mostrar permisos
            ListTile(
              title: const Text('Ver Permisos'),
              leading: Icon(Icons.security),
              onTap: () {
                // Mostrar diálogo de permisos
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Permisos Requeridos'),
                      content: Column(
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
            // Separación
            const Divider(),
            // Botón para "Acerca de nosotros"
            ListTile(
              title: const Text('Sobre Nosotros'),
              leading: Icon(Icons.info),
              onTap: () {
                // Aquí puedes agregar la navegación a la pantalla "Acerca de nosotros"
              },
            ),
            // Separación
            const Divider(),
            // Botón para cerrar sesión
            ListTile(
              title: const Text('Cerrar Sesión'),
              leading: Icon(Icons.logout),
              onTap: () {
                // Cerrar sesión
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
