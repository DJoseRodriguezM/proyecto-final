// import 'package:componentes/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewPersonalPage extends StatefulWidget {
  const NewPersonalPage({Key? key}) : super(key: key);

  @override
  _NewPersonalPageState createState() => _NewPersonalPageState();
}

class _NewPersonalPageState extends State<NewPersonalPage> {
  final nombreController = TextEditingController();
  final correoController = TextEditingController();
  final cargoController = TextEditingController();
  String cargo = 'Otro';

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 5, 93, 24),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
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
                      const SizedBox(height: 20),
                        TextFormField(
                          controller: nombreController,
                          validator: (value) {
                            if (value!.isEmpty) return 'El nombre es obligatorio';

                            return null;
                          },
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nombre del empleado',
                          ),
                        ),
                        const SizedBox(height: 20),
                          TextFormField(
                            controller: correoController,
                            validator: (value) {
                              if (value!.isEmpty) return 'El correo es obligatorio';

                              Pattern pattern =
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                              RegExp regex = RegExp(pattern.toString());

                              if (!regex.hasMatch(value)) return 'Ejemplos de correos válidos: ejemplo@dominio.com o nombre.apellido@empresa.org';

                              return null;
                            },
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Correo del empleado',
                            ),
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            value: cargo,
                            onChanged: (newValue) {
                              setState(() {
                                cargo = newValue!;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor seleccione un cargo';
                              }
                              return null;
                            },
                            items: <String>['Gerente', 'Administrador', 'Capataz', 'Veterinario', 'Trabajador', 'Seguridad','Otro']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Cargo del empleado',
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                final nombre = nombreController.text;
                                final correo = correoController.text;
                                final data = {
                                  'nombre': nombre,
                                  'correo': correo,
                                  'cargo': cargo,
                                };

                                nombreController.clear();
                                correoController.clear();

                                try {
                                  final instance = FirebaseFirestore.instance;
                                  await instance
                                      .collection('empleados')
                                      .add(data);
                                } catch (e) {
                                  print('Error al agregar el empleado: $e');
                                }

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content:
                                      Text('Empleado agregado correctamente'),
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
                            child: const Text('Guardar empleado'),
                          )
                    ],
                  )
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}