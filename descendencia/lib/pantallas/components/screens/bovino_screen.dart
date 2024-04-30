import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/widgets.dart';
import './datos_page.dart';
import './../VerTratamientosPage.dart';
import './salud_page.dart';

class BovinoScreen extends StatelessWidget {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String bovinoID;

  BovinoScreen({required this.bovinoID});

  Future<DocumentSnapshot> obtenerDocumento() async {
    final documentReference =
        FirebaseFirestore.instance.collection('Bovinos').doc(bovinoID);
    return documentReference.get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: obtenerDocumento(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')));
        } else if (!snapshot.data!.exists) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '404',
                    style: TextStyle(
                      fontSize: 100,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 94, 94, 94),
                    ),
                  ),
                  Text(
                    'QR no encontrado',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        } else {
          String Nombre = snapshot.data!.get('Identificacion');
          return Scaffold(
              appBar: AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.qr_code),
                      tooltip: 'QR Code',
                      iconSize: 35.0,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                                child: Container(
                              height: 300,
                              width: 300,
                              child: QrImage(
                                data: bovinoID,
                                version: QrVersions.auto,
                                size: 200.0,
                              ),
                            ));
                          },
                        );
                      },
                    ),
                    const SizedBox(
                        width:
                            10), // Ajusta este valor para cambiar el espacio entre el botón y el título
                    Text(Nombre),
                  ],
                ),
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 5, 93, 24),
              ),
              // Resto del código
              body: StreamBuilder<DocumentSnapshot>(
                stream:
                    firestore.collection('Bovinos').doc(bovinoID).snapshots(),
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
                                              bovinoNombre:
                                                  bovino['Identificacion'],
                                              bovinoID: bovino.id,
                                            ),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        minimumSize:
                                            const Size(double.infinity, 50),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 50),
                                        backgroundColor: const Color.fromARGB(
                                            255, 5, 93, 24),
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
                                            builder: (context) =>
                                                VerTratamientosPage(
                                                    bovinoId: bovino.id),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        minimumSize:
                                            const Size(double.infinity, 50),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 50),
                                        backgroundColor: const Color.fromARGB(
                                            255, 5, 93, 24),
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
      },
    );
  }
}
