import 'package:flutter/material.dart';

class InicioPageComp extends StatelessWidget {
  const InicioPageComp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hacienda'),
        backgroundColor: const Color.fromARGB(255, 5, 93, 24),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                color: Colors.green[100],
                child: Center(
                  child: Text('Calendario'),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.green[200],
                child: Center(
                  child: Text('Actividades del Calendario'),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.green[300],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Información Básica',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('Nombre: '),
                    Text('Día: '),
                    Text('Hora: '),
                    Text('Fecha: '),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.green[400],
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // Agregar más imágenes según sea necesario
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
