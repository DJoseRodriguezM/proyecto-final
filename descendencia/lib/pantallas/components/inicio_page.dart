import 'package:flutter/material.dart';

class InicioPageComp extends StatelessWidget {
  const InicioPageComp({ super.key });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hacienda'),
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


