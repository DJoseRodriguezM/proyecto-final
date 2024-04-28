import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewBovino extends StatelessWidget {
  final identificacionController = TextEditingController();
  final pesoController = TextEditingController();
  final propositoController = TextEditingController();
  final razaController = TextEditingController();
  final saludController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo con imagen
          Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/barra.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),

          // Contenido de la página
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 200),
                TextField(
                  controller: identificacionController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Identificacion del animal',
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: pesoController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Peso en lb',
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: propositoController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Leche/Carne',
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: razaController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Raza',
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: saludController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Estado Del animal',
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    final data = {
                      'Identifiacion': identificacionController.text,
                      'Peso': pesoController.text,
                      'Proposito': propositoController.text,
                      'Raza': razaController.text,
                      'Salud': saludController.text
                    };

                    final instance = FirebaseFirestore.instance;
                    await instance.collection('Bovinos').add(data);

                    Navigator.pop(context);
                  },
                  child: Text('Agregar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
