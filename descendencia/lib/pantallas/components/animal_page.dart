import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'new_bovino_page.dart';

class AnimalPage extends StatelessWidget {
  const AnimalPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bovinos'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Bovinos')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final listaBovinos = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: listaBovinos.length,
                      itemBuilder: (context, index) {
                        final bovinos = listaBovinos[index];
                        return ListTile(
                          title: Text(bovinos['Identificacion']),
                          subtitle: Text(bovinos['Proposito']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('${bovinos['Raza']}'),
                              SizedBox(
                                  width: 8), // Espacio entre el año y los votos
                              Text('${bovinos['Peso']}'),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
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
            MaterialPageRoute(builder: (context) => NewBovino()),
          );
        },
        tooltip: 'Nuevo Bovino',
        child: Icon(Icons.add),
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
