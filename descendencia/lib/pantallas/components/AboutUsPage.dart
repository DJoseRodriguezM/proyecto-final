import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre Nosotros'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 5, 93, 24),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Historia de Agro-Apps',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Agro-Apps es una compañía dedicada al desarrollo de soluciones tecnológicas para el sector agrícola. Fundada en 2024, nuestra misión es modernizar el sector agricola de forma economica eficaz y habil',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Nuestro Equipo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Aquí puedes agregar información sobre los miembros del equipo
            // Por ejemplo:
            // - Nombre
            // - Rol en la compañía
            // - Breve descripción
            // - Foto (opcional)
          ],
        ),
      ),
    );
  }
}
