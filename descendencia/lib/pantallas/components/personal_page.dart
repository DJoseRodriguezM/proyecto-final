// import 'package:componentes/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:descendencia/pantallas/components/new_personal_page.dart';
import 'package:flutter/material.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({Key? key}) : super(key: key);

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 5, 93, 24),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('empleados')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Algo salió mal');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Cargando...");
                  }

                  return ListView(
                    shrinkWrap: true,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      return Dismissible(
                        key: Key(document.id),
                        direction: DismissDirection.startToEnd,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          // Muestra un diálogo de confirmación antes de eliminar el empleado
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Confirmar eliminación'),
                                content: Text(
                                    '¿Está seguro de que desea eliminar este empleado?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      // Elimina el empleado de Firestore
                                      await firestore
                                          .collection('empleados')
                                          .doc(document.id)
                                          .delete();
                                      Navigator.of(context).pop(true);
                                    },
                                    child: Text('Eliminar'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              leading: const Icon(Icons.account_circle,
                                  color: Colors.green, size: 50),
                              title: Text(
                                data['nombre'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              subtitle: Text(
                                'Correo: ${data['correo']}\nCargo: ${data['cargo']}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewPersonalPage()),
          );
        },
        tooltip: 'Nuevo Empleado',
        backgroundColor: const Color.fromARGB(255, 5, 93, 24),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
