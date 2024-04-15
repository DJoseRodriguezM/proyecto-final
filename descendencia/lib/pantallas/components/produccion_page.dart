import 'package:flutter/material.dart';

class ProduccionPage extends StatelessWidget {
  const ProduccionPage({ super.key });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Producción'),
        backgroundColor: const Color.fromARGB(185, 0, 93, 20)
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


