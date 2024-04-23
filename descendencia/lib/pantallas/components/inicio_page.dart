import 'package:flutter/material.dart';

class InicioPageComp extends StatelessWidget {
  const InicioPageComp({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hacienda'),
        backgroundColor: const Color.fromARGB(255, 5, 93, 24),
      ),
    );
  }
}
