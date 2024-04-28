import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import './bovino_screen.dart';

class DatosPage extends StatelessWidget {
  final String bovinoNombre;
  final String bovinoID;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  DatosPage({required this.bovinoNombre, required this.bovinoID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Datos Generales"),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 15.0),
                              Text('Nombre: ${bovino['Identificacion']}',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 15.0),
                              Text('Edad: ',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 15.0),
                              Text('Sexo: ',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 15.0),
                              Text('Raza: ${bovino['Raza']}',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 15.0),
                              Text('Fecha de Nacimiento: ',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 15.0),
                              Text('Lote: ${bovino['Proposito']}',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 15.0),
                              Text('Peso: ${bovino['Peso']} lb',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 15.0),
                              const Text('Padres:',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 15.0),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Padre:',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold)),
                                    buildBovinoCard(bovinoID),
                                    const SizedBox(height: 15.0),
                                    const Text('Madre:',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold)),
                                    buildBovinoCard(bovinoID),
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

  Widget buildBovinoCard(String bovinoId) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return StreamBuilder<DocumentSnapshot>(
      stream: firestore.collection('Bovinos').doc(bovinoId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final bovino = snapshot.data!;
          return Card(
            margin: const EdgeInsets.all(8.0),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BovinoScreen(
                      bovinoNombre: bovino['Identificacion'],
                      bovinoID: bovino.id,
                    ),
                  ),
                );
              },
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: bovino['perfilV'] !=
                        '' //si hay una ruta de imagen en la base de datos
                    ? Image.network(
                        bovino['perfilV'],
                        fit: BoxFit.cover,
                        height: 60.0,
                        width: 60.0,
                      )
                    : Image.asset(
                        //si NO HAY una ruta de imagen en la base de datos, carga una local
                        'assets/perfilV.png',
                        fit: BoxFit.cover,
                        height: 60.0,
                        width: 60.0,
                      ),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              title: Text(
                bovino['Identificacion'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(bovino['Proposito']),
              trailing: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(bovino['Raza'],
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
