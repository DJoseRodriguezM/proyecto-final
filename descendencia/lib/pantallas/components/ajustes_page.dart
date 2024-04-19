import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AjustesPage extends StatelessWidget {
  const AjustesPage({ super.key });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
        backgroundColor: const Color.fromARGB(255, 5, 93, 24),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return const ListTile(
            
          );
        },
      ),
    );
  }
}


