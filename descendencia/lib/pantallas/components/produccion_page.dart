import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:descendencia/pantallas/components/animal_page.dart';
import 'package:descendencia/routes.dart';
import 'package:flutter/material.dart';

class ProduccionPage extends StatefulWidget {
  final String hacienda;
  const ProduccionPage({Key? key, required this.hacienda}) : super(key: key);
  
  @override
  _ProduccionPageState createState() => _ProduccionPageState();
}
  
class _ProduccionPageState extends State<ProduccionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Producción'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 5, 93, 24),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnimalPage(hacienda: widget.hacienda),
                      ), 
                  );
                  //Navigator.pushReplacementNamed(context, MyRoutes.animales.name, arguments: {'haciendaID': widget.hacienda});
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  backgroundColor: const Color.fromARGB(255, 5, 93, 24),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/animales.png',
                      width: 100, // Adjust the width of the image
                      height: 100, // Adjust the height of the image
                    ),
                    const Text('Animales'),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, MyRoutes.personal.name);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  backgroundColor: const Color.fromARGB(255, 5, 93, 24),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10.0),
                    Image.asset(
                      'assets/personal.png',
                      width: 100, // Adjust the width of the image
                      height: 70, // Adjust the height of the image
                    ),
                    const SizedBox(height: 10.0),
                    const Text('Personal'),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, MyRoutes.almacenamiento.name);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  backgroundColor: const Color.fromARGB(255, 5, 93, 24),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10.0),
                    Image.asset(
                      'assets/almacenamiento.png',
                      width: 100, // Adjust the width of the image
                      height: 70, // Adjust the height of the image
                    ),
                    const SizedBox(height: 10.0),
                    const Text('Almacenamiento'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
