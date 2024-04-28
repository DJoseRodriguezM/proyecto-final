import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class NewBovino extends StatelessWidget {
  final identificacionController = TextEditingController();
  final pesoController = TextEditingController();
  final propositoController = TextEditingController();
  final razaController = TextEditingController();
  final saludController = TextEditingController();
  final fechaNacimientoController = TextEditingController();
  final sexoController = TextEditingController();
  final padreController = TextEditingController();
  final madreController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(0.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    //Imagen de la página
                    height: 200,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/barra.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 50),
                          TextFormField(
                            controller: identificacionController,
                            validator: (value) {
                              if (value!.isEmpty)
                                return 'La identificacion es obligatoria';

                              return null;
                            },
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Nombre del animal',
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: fechaNacimientoController,
                            validator: (value) {
                              if (value!.isEmpty)
                                return 'La fecha de nacimiento es obligatoria';

                              return null;
                            },
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Fecha de nacimiento',
                            ),
                            onTap: () async {
                              FocusScope.of(context).requestFocus(
                                  new FocusNode()); // para quitar el teclado
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (picked != null) {
                                fechaNacimientoController.text =
                                    DateFormat('yyyy-MM-dd').format(picked);
                              }
                            },
                          ),
                          const SizedBox(height: 16.0),
                          DropdownButtonFormField<String>(
                            value: sexoController.text.isEmpty
                                ? null
                                : sexoController.text,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Sexo',
                            ),
                            items: <String>['Hembra', 'Macho']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              sexoController.text = newValue!;
                            },
                            validator: (value) {
                              if (value!.isEmpty)
                                return 'El sexo es obligatorio';

                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: pesoController,
                            validator: (value) {
                              if (value!.isEmpty)
                                return 'El peso es obligatorio';

                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Peso en lb',
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: razaController,
                            validator: (value) {
                              if (value!.isEmpty)
                                return 'La raza es obligatoria';

                              return null;
                            },
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Raza',
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          DropdownButtonFormField<String>(
                            value: padreController.text.isEmpty
                                ? null
                                : padreController.text,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Padre',
                            ),
                            items: <String>['Padre1', 'Padre2', 'Padre3']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              padreController.text = newValue!;
                            },
                            validator: (value) {
                              if (value!.isEmpty)
                                return 'El campo padre es obligatorio';

                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          DropdownButtonFormField<String>(
                            value: madreController.text.isEmpty
                                ? null
                                : madreController.text,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Madre',
                            ),
                            items: <String>['Madre1', 'Madre2', 'Madre3']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              madreController.text = newValue!;
                            },
                            validator: (value) {
                              if (value!.isEmpty)
                                return 'El campo Madre es obligatorio';

                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          DropdownButtonFormField<String>(
                            value: propositoController.text.isEmpty
                                ? null
                                : propositoController.text,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Leche/Carne',
                            ),
                            items: <String>['Leche', 'Carne']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              propositoController.text = newValue!;
                            },
                            validator: (value) {
                              if (value!.isEmpty)
                                return 'El proposito es obligatorio';

                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: saludController,
                            validator: (value) {
                              if (value!.isEmpty)
                                return 'El estado es obligatorio';

                              return null;
                            },
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Estado Del animal',
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                final data = {
                                  'Identificacion':
                                      identificacionController.text,
                                  'Peso': pesoController.text,
                                  'Proposito': propositoController.text,
                                  'Raza': razaController.text,
                                  'Estado': saludController.text,
                                  'perfilV': ''
                                };

                                try {
                                  final instance = FirebaseFirestore.instance;
                                  await instance
                                      .collection('Bovinos')
                                      .add(data);
                                } catch (e) {
                                  print('Error al agregar el bovino: $e');
                                }

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content:
                                      Text('Bovino agregado correctamente'),
                                ));

                                Navigator.pop(context);
                              }
                            },
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
                              backgroundColor:
                                  const Color.fromARGB(255, 5, 93, 24),
                            ),
                            child: const Text(
                              "Agregar",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Contenido de la página
            )));
  }
}
