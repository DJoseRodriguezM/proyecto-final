import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:descendencia/pantallas/login_page.dart';

class AjustesPage extends StatelessWidget {
  const AjustesPage({ super.key });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
        foregroundColor: Colors.white,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton
              (onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginPage()));
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                minimumSize: const Size(60, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 50,
                ),
                backgroundColor: const Color.fromARGB(255, 255, 0, 0),
              ),
              child: const Text('Logout')
              ),
            ),
          ],
        )      )
    );
  }
}
