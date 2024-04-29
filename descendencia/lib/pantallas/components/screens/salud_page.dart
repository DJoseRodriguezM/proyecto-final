import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
//import './datos_page.dart';

class SaludPage extends StatelessWidget {
  final String bovinoNombre;
  final String bovinoID;

  SaludPage({required this.bovinoNombre, required this.bovinoID});

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Salud"),
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
                        const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              SizedBox(height: 15.0),
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
