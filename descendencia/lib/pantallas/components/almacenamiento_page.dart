import 'package:flutter/material.dart';

class AlmacenamientoPage extends StatelessWidget {
  const AlmacenamientoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Almacenamiento'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 5, 93, 24),
      ),
      body: SafeArea(
        child: Column(
          children: [],
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
