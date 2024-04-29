import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
                Container(
                  color: const Color.fromARGB(255, 209, 209, 209),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 50, // Ajusta esto al tamaño de tus botones
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          boton('Todos', 1, Colors.green),
                          const SizedBox(width: 10), // Espacio entre botones
                          boton('Leche', 2, Colors.green),
                          const SizedBox(width: 10), // Espacio entre botones
                          boton('Carne', 3, Colors.green),
                          const SizedBox(width: 10), // Espacio entre botones
                          boton('Machos', 4, const Color.fromARGB(255, 12, 115, 200)), 
                          const SizedBox(width: 10), // Espacio entre botones
                          boton('Hembras', 5, const Color.fromARGB(255, 175, 44, 198)),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                  itemCount: x == 1
                      ? listaBovinos.length
                      : listaBovinos
                          .where((bovino) => x == 2
                              ? bovino['Proposito'] == 'Leche'
                              : x == 3
                                  ? bovino['Proposito'] == 'Carne'
                                  : x == 4
                                      ? bovino['Sexo'] == 'Macho'
                                      : bovino['Sexo'] == 'Hembra')
                          .length,
                  itemBuilder: (context, index) {
                    final bovino = x == 1
                        ? listaBovinos[index]
                        : listaBovinos
                            .where((bovino) => x == 2
                                ? bovino['Proposito'] == 'Leche'
                                : x == 3
                                    ? bovino['Proposito'] == 'Carne'
                                    : x == 4
                                        ? bovino['Sexo'] == 'Macho'
                                        : bovino['Sexo'] == 'Hembra')
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

  Widget boton(String texto, int valor, Color color) {
    return ElevatedButton(
      onPressed: () {
        // Acción del botón
        setState(() {
          x = valor; // Cambia esto al valor que quieras asignar a x
        });
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
            color), // Color de fondo del botón
        padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(
              horizontal: 6, vertical: 6), // Padding del botón
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Radio del borde
          ),
        ),
      ),
      child: Text(
        texto,
        style: const TextStyle(
          color: Colors.white, // Color del texto
          fontSize: 14, // Tamaño del texto
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({super.key, required this.text, this.onPressed});

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
