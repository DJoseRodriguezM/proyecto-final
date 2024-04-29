import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import './bovino_screen.dart';

class DatosPage extends StatefulWidget {
  final String bovinoNombre;
  final String bovinoID;

  const DatosPage(
      {Key? key, required this.bovinoNombre, required this.bovinoID})
      : super(key: key);

  @override
  _DatosPageState createState() => _DatosPageState();
}

class _DatosPageState extends State<DatosPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String bovinoID = '';
  String padreID = '';
  String madreID = '';

  @override
  void initState() {
    super.initState();
    bovinoID = widget.bovinoID;

    _fetchData();
  }

  void _fetchData() async {
    final bovino = await firestore.collection('Bovinos').doc(bovinoID).get();
    final bovinos = await firestore.collection('Bovinos').get();
    final padreNombre = bovino.data()?['Padre'];
    if (padreNombre == 'No Registrado') {
      padreID = '';
    } else {
      padreID = bovinos.docs
          .where((padre) => padre['Identificacion'] == padreNombre)
          .first
          .id;
    }

    final madreNombre = bovino.data()?['Madre'];

    if (madreNombre == 'No Registrada') {
      madreID = '';
    } else {
      madreID = bovinos.docs
          .where((madre) => madre['Identificacion'] == madreNombre)
          .first
          .id;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Datos Generales"),
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 5, 93, 24),
        ),
        // Resto del código
        body: StreamBuilder<DocumentSnapshot>(
          stream: firestore.collection('Bovinos').doc(bovinoID).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final bovino = snapshot.data!;
              DateTime fechaNac = bovino['FechaNacimiento'].toDate();
              DateTime hoy = DateTime.now();

              int edadAnos = hoy.year - fechaNac.year;
              int edadMeses = hoy.month - fechaNac.month;

              if (hoy.day < fechaNac.day) {
                edadMeses--;
              }

              if (edadMeses < 0) {
                edadAnos--;
                edadMeses += 12;
              }

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
                              Text(
                                  edadAnos > 0
                                      ? 'Edad: $edadAnos años ${edadMeses > 0 ? 'y $edadMeses ${edadMeses > 1 ? 'meses' : 'mes'}' : ''}'
                                      : 'Edad: $edadMeses ${edadMeses > 1 ? 'meses' : 'mes'}',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 15.0),
                              Text('Sexo: ${bovino['Sexo']}',
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
                              Text('Fecha de Nacimiento: ${bovino['FechaNacimiento'].toDate().toString().substring(0, 10)}',
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
                                    buildBovinoCard(padreID),
                                    const SizedBox(height: 15.0),
                                    const Text('Madre:',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold)),
                                    buildBovinoCard(madreID),
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
    if (bovinoId == '') {
      return Card(
        margin: const EdgeInsets.all(8.0),
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Image.asset(
              'assets/perfilV.png',
              fit: BoxFit.cover,
              height: 60.0,
              width: 60.0,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          title: const Text('No disponible'),
        ),
      );
    } else {
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
}
