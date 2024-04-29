import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'VerTratamientosPage.dart';

class TratamientosPage extends StatelessWidget {
  const TratamientosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var streamBuilder = StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Bovinos').snapshots()
          as Stream<QuerySnapshot>?,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final bovinos = snapshot.data!.docs;
          return ListView.builder(
            itemCount: bovinos.length,
            itemBuilder: (context, index) {
              final bovino = bovinos[index];
              return ListTile(
                title: Text('${bovino['Identificacion']} - ${bovino.id}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                VerTratamientosPage(bovinoId: bovino.id),
                          ),
                        );
                      },
                      icon: Icon(Icons.visibility),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tratamientos'),
        backgroundColor: const Color.fromARGB(255, 5, 93, 24),
        foregroundColor: Colors.white,
      ),
      body: streamBuilder,
    );
  }
}
