import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'new_bovino_page.dart';
import './screens/bovino_screen.dart';

class AnimalPage extends StatefulWidget {
  const AnimalPage({Key? key}) : super(key: key);

  @override
  State<AnimalPage> createState() => _AnimalPageState();
}

class _AnimalPageState extends State<AnimalPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int x = 1;

  @override
  Widget build(BuildContext context) {
    final bovinos = firestore.collection('Bovinos').snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bovinos'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 5, 93, 24),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: bovinos,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final listaBovinos = snapshot.data!.docs;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            x = 1; // Cambia esto al valor que quieras asignar a x
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.green), // Color de fondo del botón
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12), // Padding del botón
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(30), // Radio del borde
                            ),
                          ),
                        ),
                        child: const Text(
                          'Todos',
                          style: TextStyle(
                            color: Colors.white, // Color del texto
                            fontSize: 16, // Tamaño del texto
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Acción del botón
                          setState(() {
                            x = 2; // Cambia esto al valor que quieras asignar a x
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.green), // Color de fondo del botón
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12), // Padding del botón
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(30), // Radio del borde
                            ),
                          ),
                        ),
                        child: const Text(
                          'Leche',
                          style: TextStyle(
                            color: Colors.white, // Color del texto
                            fontSize: 16, // Tamaño del texto
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Acción del botón
                          setState(() {
                            x = 3; // Cambia esto al valor que quieras asignar a x
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.green), // Color de fondo del botón
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12), // Padding del botón
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(30), // Radio del borde
                            ),
                          ),
                        ),
                        child: const Text(
                          'Carne',
                          style: TextStyle(
                            color: Colors.white, // Color del texto
                            fontSize: 16, // Tamaño del texto
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                  itemCount: x == 1
                      ? listaBovinos.length
                      : listaBovinos
                          .where((bovino) => x == 2
                              ? bovino['Proposito'] == 'Leche'
                              : bovino['Proposito'] == 'Carne')
                          .length,
                  itemBuilder: (context, index) {
                    final bovino = x == 1
                        ? listaBovinos[index]
                        : listaBovinos
                            .where((bovino) => x == 2
                                ? bovino['Proposito'] == 'Leche'
                                : bovino['Proposito'] == 'Carne')
                            .toList()[index];

                    return Column(
                      children: [
                        Card(
                          margin: const EdgeInsets.all(8.0),
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            onTap: () {
                              // Acción al hacer clic en el bovino
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
                                child: bovino['perfilV'] != '' //si hay una ruta de imagen en la base de datos
                                    ? Image.network(
                                        bovino['perfilV'],
                                        fit: BoxFit.cover,
                                        height: 60.0,
                                        width: 60.0,
                                      )
                                    : Image.asset( //si NO HAY una ruta de imagen en la base de datos, carga una local
                                        'assets/perfilV.png',
                                        fit: BoxFit.cover,
                                        height: 60.0,
                                        width: 60.0,
                                      ),
                              ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            title: Text(
                              bovino['Identificacion'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(bovino['Proposito']),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(bovino['Raza']),
                                const SizedBox(
                                    width:
                                        8), // Espacio entre la raza y el peso
                                Text(bovino['Peso'].toString()),
                                Text(bovino['Estado'])
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ))
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewBovino()),
          );
        },
        tooltip: 'Nuevo Bovino',
        backgroundColor: const Color.fromARGB(255, 5, 93, 24),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({Key? key, required this.text, this.onPressed});

  final String text;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
