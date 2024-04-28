import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import './datos_page.dart';
import './salud_page.dart';

class BovinoScreen extends StatelessWidget {
  final String bovinoNombre;
  final String bovinoID;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  BovinoScreen({required this.bovinoNombre, required this.bovinoID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(bovinoNombre),
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 5, 93, 24),
        ),
        // Resto del código
        body: StreamBuilder<DocumentSnapshot>(
          stream: firestore.collection('Bovinos').doc(bovinoID).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final bovino = snapshot.data!;
              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: bovino['perfilV'] !=
                                  '' //si hay una ruta de imagen en la base de datos
                              ? Image.network(
                                  bovino['perfilV'],
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  //si NO HAY una ruta de imagen en la base de datos, carga una local
                                  'assets/perfilV.png',
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 15.0),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DatosPage(
                                        bovinoNombre: bovino['Identificacion'],
                                        bovinoID: bovino.id,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 50),
                                  backgroundColor:
                                      const Color.fromARGB(255, 5, 93, 24),
                                ),
                                child: const Column(
                                  children: [
                                    Icon(Icons.info_outline, size: 80),
                                    SizedBox(height: 10.0),
                                    Text('Datos Generales'),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SaludPage(
                                        bovinoNombre: bovino['Identificacion'],
                                        bovinoID: bovino.id,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 50),
                                  backgroundColor:
                                      const Color.fromARGB(255, 5, 93, 24),
                                ),
                                child: const Column(
                                  children: [
                                    Icon(Icons.health_and_safety_outlined,
                                        size: 80),
                                    SizedBox(height: 10.0),
                                    Text('Salud'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
