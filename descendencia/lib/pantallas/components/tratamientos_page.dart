import 'package:flutter/material.dart';

class TratamientosPage extends StatelessWidget {
  const TratamientosPage({ super.key });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tratamientos'),
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


