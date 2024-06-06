import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class VerTratamientosPage extends StatelessWidget {
  final String bovinoId;

  const VerTratamientosPage({Key? key, required this.bovinoId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tratamientos del Bovino'),
        backgroundColor: const Color.fromARGB(255, 5, 93, 24),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetalleBovinoPage(bovinoId: bovinoId),
                ),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('tratamientos')
              .where('BovinoId', isEqualTo: bovinoId)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final tratamientos = snapshot.data!.docs;
              if (tratamientos.isEmpty) {
                return Center(
                  child:
                      Text('No hay tratamientos registrados para este bovino'),
                );
              } else {
                return ListView.builder(
                  itemCount: tratamientos.length,
                  itemBuilder: (context, index) {
                    final tratamiento = tratamientos[index];
                    return Dismissible(
                      key: Key(tratamiento.id),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20.0),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        FirebaseFirestore.instance
                            .collection('tratamientos')
                            .doc(tratamiento.id)
                            .delete();
                      },
                      child: ListTile(
                        leading: CircleAvatar(),
                        title: Text('Tratamiento: ${tratamiento['Nombre']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Dosis: ${tratamiento['Dosis']}'),
                            Text(
                                'Fecha: ${DateFormat('dd/MM/yyyy').format(tratamiento['Fecha'].toDate())}'),
                            Text('Medicamento: ${tratamiento['Medicamento']}'),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            }
          },
        ),
      ),
    );
  }
}

class DetalleBovinoPage extends StatefulWidget {
  final String bovinoId;

  const DetalleBovinoPage({Key? key, required this.bovinoId}) : super(key: key);

  @override
  _DetalleBovinoPageState createState() => _DetalleBovinoPageState();
}

class _DetalleBovinoPageState extends State<DetalleBovinoPage> {
  final _formKey = GlobalKey<FormState>();
  String _selectedTratamiento = '';
  String _dosis = '';
  DateTime _fechaInicio = DateTime.now();
  String _medicamento = '';

  final List<String> nombresTratamientos = [
    'Fiebre Aftosa',
    'Mastitis',
    'Coccidiosis',
    'Neumonía',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Tratamiento'),
        backgroundColor: const Color.fromARGB(255, 5, 93, 24),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   'Seleccione el tipo de tratamiento:',
                //   style: TextStyle(fontSize: 16),
                // ),
                // DropdownButton<String>(
                //   value: _selectedTratamiento.isNotEmpty
                //       ? _selectedTratamiento
                //       : null,
                //   onChanged: (String? newValue) {
                //     setState(() {
                //       _selectedTratamiento = newValue!;
                //     });
                //   },
                //   items: nombresTratamientos.map((String value) {
                //     return DropdownMenuItem<String>(
                //       value: value,
                //       child: Text(value),
                //     );
                //   }).toList(),
                // ),

                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Tipo de tratamiento',
                    labelStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _selectedTratamiento = value;
                    });
                  },
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 20),
                // Divider(),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Medicamento'),
                  onChanged: (value) {
                    setState(() {
                      _medicamento = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Dosis'),
                  onChanged: (value) {
                    setState(() {
                      _dosis = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                Text(
                  'Fecha de inicio:',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: _seleccionarFechaInicio,
                  child: Text(
                    DateFormat('dd/MM/yyyy').format(_fechaInicio),
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _guardarTratamiento();
                      }
                    },
                    child: Text('Guardar Tratamiento'),
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _seleccionarFechaInicio() async {
    final DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: _fechaInicio,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (fechaSeleccionada != null && fechaSeleccionada != _fechaInicio) {
      setState(() {
        _fechaInicio = fechaSeleccionada;
      });
    }
  }

  void _guardarTratamiento() async {
    try {
      await FirebaseFirestore.instance.collection('tratamientos').add({
        'Nombre': _selectedTratamiento,
        'Dosis': _dosis,
        'Fecha': _fechaInicio,
        'Medicamento': _medicamento,
        'BovinoId': widget.bovinoId,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tratamiento guardado correctamente')),
      );
    } catch (e) {
      print('Error al guardar el tratamiento: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar el tratamiento')),
      );
    }
  }
}
