import 'package:descendencia/routes.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GeneralPage extends StatefulWidget {
  const GeneralPage({Key? key, required this.emailId}) : super(key: key);
  final String emailId;
  
  @override
  _GeneralPageState createState() => _GeneralPageState();
}

class _GeneralPageState extends State<GeneralPage> {
  final formKey = GlobalKey<FormState>();
  final instance = FirebaseFirestore.instance;
  final nombre = TextEditingController();
  final haciendaArea = TextEditingController();
  final ganaderiaArea = TextEditingController();
  final areaMedida = TextEditingController();

  String haciendaID = '';
  String userID = '';

  @override
  void initState() {
    super.initState();
    // Genera un ID único para la hacienda cuando se inicializa la página
    haciendaID = FirebaseFirestore.instance.collection('hacienda').doc().id;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userID = ModalRoute.of(context)!.settings.arguments as String;
  }

  @override
  Widget build(BuildContext context) {
    if (userID.isNotEmpty) {
      instance.collection('hacienda').doc(userID).get().then((value) {
        nombre.text = value['nombre'];
        haciendaArea.text = value['haciendaarea'].toString();
        ganaderiaArea.text = value['ganaderiaarea'].toString();
        areaMedida.text = value['areamedida'];
      });
    }

    return Scaffold(
      appBar: AppBar(
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        backgroundColor: const Color.fromARGB(255, 5, 93, 24),
        title: const Text('General Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/general.png',
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 20),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nombre,
                      maxLength: 20,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Ingresa un nombre';
                        }

                        return null;
                      },
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        errorMaxLines: 2,
                        labelText: 'Nombre',
                        icon: Icon(
                          Icons.add_home_outlined,
                          color: Color.fromARGB(255, 5, 93, 24),
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: haciendaArea,
                      maxLength: 20,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Ingresa el area';
                        }

                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        errorMaxLines: 2,
                        labelText: 'Area de la Hacienda',
                        icon: Icon(
                          Icons.area_chart_outlined,
                          color: Color.fromARGB(255, 5, 93, 24),
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: ganaderiaArea,
                      maxLength: 20,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Ingresa el area de ganaderia';
                        }

                        return null;
                      },
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        errorMaxLines: 2,
                        labelText: 'Area para ganaderia',
                        icon: Icon(
                          Icons.agriculture_outlined,
                          color: Color.fromARGB(255, 5, 93, 24),
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: areaMedida,
                      maxLength: 20,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Ingresa la medida del area';
                        }

                        return null;
                      },
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        errorMaxLines: 2,
                        labelText: 'Medida del area',
                        icon: Icon(
                          Icons.aspect_ratio_outlined,
                          color: Color.fromARGB(255, 5, 93, 24),
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        backgroundColor: const Color.fromARGB(255, 5, 93, 24),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          try {
                            final instance = FirebaseFirestore.instance;
                            final docRef = instance.collection('hacienda').doc();

                            final data = {
                            'nombre': nombre.text,
                            'haciendaarea': haciendaArea.text,
                            'ganaderiaarea': ganaderiaArea.text,
                            'areamedida': areaMedida.text,
                            'haciendaID' : docRef.id,
                            'userID' : userID,
                            };

                            ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Hacienda Registrada')));

                            Navigator.pushReplacementNamed(
                              context, MyRoutes.inicioroute.name);

                            await docRef.set(data);
                          } catch (e) {
                            print('Error al registrar el usuario: $e');
                          }
                          
                          return;
                        }
                      },
                      child: const Text('Guardar Hacienda'),
                    ),
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
