import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AlmacenamientoPage extends StatelessWidget {
  const AlmacenamientoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Almacenamiento'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 5, 93, 24),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: _InventoryForm(),
        ),
      ),
    );
  }
}

class _InventoryForm extends StatefulWidget {
  const _InventoryForm({Key? key}) : super(key: key);

  @override
  __InventoryFormState createState() => __InventoryFormState();
}

class __InventoryFormState extends State<_InventoryForm> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  void _saveDataToFirestore() async {
    final String productName = _productNameController.text.trim();
    final int quantity = int.tryParse(_quantityController.text.trim()) ?? 0;

    if (productName.isNotEmpty && quantity > 0) {
      await FirebaseFirestore.instance.collection('inventory').add({
        'product': productName,
        'quantity': quantity,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos guardados correctamente')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Por favor, completa todos los campos correctamente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _productNameController,
          decoration: const InputDecoration(labelText: 'Producto'),
        ),
        TextFormField(
          controller: _quantityController,
          decoration: const InputDecoration(labelText: 'Cantidad'),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 50,
            ),
            backgroundColor: const Color.fromARGB(255, 5, 93, 24),
          ),
          onPressed: _saveDataToFirestore,
          child: const Text('Guardar'),
        ),
        const SizedBox(height: 20),
        _InventoryList(),
      ],
    );
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }
}

class _InventoryList extends StatelessWidget {
  const _InventoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('inventory').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los datos'));
          }
          final List<DocumentSnapshot> documents = snapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final Map<String, dynamic> data =
                documents[index].data() as Map<String, dynamic>;

              int quantity = data['quantity'];

              return Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.endToStart,
                background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20.0),
                child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (DismissDirection direction) async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Color.fromARGB(244, 255, 255, 255),
                    title: const Text("Confirmar eliminación"),
                    content: const Text(
                    "¿Estás seguro de que deseas eliminar este elemento?",
                    ),
                    actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(
                      "Cancelar",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 26, 26, 26)),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(
                      "Eliminar",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 19, 0, 0)),
                      ),
                    ),
                    ],
                  );
                  },
                );
                },
                onDismissed: (direction) {
                FirebaseFirestore.instance
                  .collection('inventory')
                  .doc(documents[index].id)
                  .delete();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Producto eliminado')),
                );
                },
                child: ListTile(
                title: Text(data['product']),
                subtitle: Text('Cantidad: $quantity'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                    if (quantity > 0) {
                      FirebaseFirestore.instance
                        .collection('inventory')
                        .doc(documents[index].id)
                        .update({'quantity': quantity - 1});
                    }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                    FirebaseFirestore.instance
                      .collection('inventory')
                      .doc(documents[index].id)
                      .update({'quantity': quantity + 1});
                    },
                  ),
                  ],
                ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: AlmacenamientoPage(),
  ));
}
