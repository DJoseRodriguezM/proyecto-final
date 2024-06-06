import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'VerTratamientosPage.dart';

class TratamientosPage extends StatelessWidget {
  const TratamientosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tratamientos'),
        backgroundColor: const Color.fromARGB(255, 5, 93, 24),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Bovinos').snapshots(),
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
                final bovinoData = bovino.data() as Map<String, dynamic>;
                final identificacion = bovinoData['Identificacion'] ??
                    'Identificación no disponible';
                return ListTile(
                  title: Text(identificacion),
                  trailing: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              VerTratamientosPage(bovinoId: bovino.id),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.monitor_heart,
                      color: const Color.fromARGB(255, 5, 93, 24),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
