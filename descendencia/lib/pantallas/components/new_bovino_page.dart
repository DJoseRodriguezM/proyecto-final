import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class NewBovino extends StatefulWidget {

  String? bovinoID = '';
  String haciendaID;

  NewBovino({super.key, this.bovinoID, required this.haciendaID});
  @override
  _NewBovinoState createState() => _NewBovinoState();
}

class _NewBovinoState extends State<NewBovino> {
  
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
  final instance = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance.ref();

  String? imgUrl;
  List<String> imagesUrls = [];

  List<String> bovinoListHembra = ['No Registrada'];
  List<String> bovinoListMacho = ['No Registrado'];

  @override
  void initState() {
    super.initState();

    _fetchData();
  }

void _fetchData() async {
final bovinos = await instance.collection('Bovinos').get();
    setState(() {
      bovinoListHembra.addAll(bovinos.docs
          .where((bovino) => bovino['Sexo'] == 'Hembra')
          .map((bovino) => bovino['Identificacion'] as String));

      bovinoListMacho.addAll(bovinos.docs
          .where((bovino) => bovino['Sexo'] == 'Macho')
          .map((bovino) => bovino['Identificacion'] as String));
    });
    // print(widget.bovinoID);

    if (widget.bovinoID != null && widget.bovinoID!.isNotEmpty) {
      final bovinoDoc = await instance.collection('Bovinos').doc(widget.bovinoID).get();
      final bovinoData = bovinoDoc.data();

      if (bovinoData != null) {
        identificacionController.text = bovinoData['Identificacion'];
        pesoController.text = bovinoData['Peso'].toString();
        propositoController.text = bovinoData['Proposito'];
        razaController.text = bovinoData['Raza'];
        saludController.text = bovinoData['Estado'];
        fechaNacimientoController.text = bovinoData['FechaNacimiento'].toDate().toString().substring(0,10);
        sexoController.text = bovinoData['Sexo'];
        padreController.text = bovinoData['Padre'];
        madreController.text = bovinoData['Madre'];
        imgUrl = bovinoData['perfilV'] ?? '';
        imagesUrls = List<String>.from(bovinoData['Fotos']) ?? [];
      }
    }
}


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
                              if (value!.isEmpty) {
                                return 'El nombre es obligatorio';
                              }

                              if (bovinoListHembra.contains(value) ||
                                  bovinoListMacho.contains(value)) {
                                return 'El nombre ya existe';
                              }

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
                              if (value!.isEmpty) {
                                return 'La fecha de nacimiento es obligatoria';
                              }

                              return null;
                            },
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Fecha de nacimiento',
                            ),
                            onTap: () async {
                              FocusScope.of(context).requestFocus(
                                  FocusNode()); // para quitar el teclado
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
                            items: <String>['Macho', 'Hembra']
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
                              if (value == null || value.isEmpty) {
                                return 'Por favor selecciona una opción';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: pesoController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'El peso es obligatorio';
                              }

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
                              if (value!.isEmpty) {
                                return 'La raza es obligatoria';
                              }

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
                            items: bovinoListMacho
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
                              if (value == null || value.isEmpty) {
                                return 'Por favor selecciona una opción';
                              }

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
                            items: bovinoListHembra
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
                              if (value == null || value.isEmpty) {
                                return 'Por favor selecciona una opción';
                              }

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
                              if (value == null || value.isEmpty) {
                                return 'Por favor selecciona una opción';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: saludController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'El estado es obligatorio';
                              }

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
                              final ImagePicker picker = ImagePicker();
                              XFile? image = await picker.pickImage(
                                  source: ImageSource.gallery);

                              if (image != null) {
                                Reference imagenRef = storage.child(
                                    'images/${DateTime.now().millisecondsSinceEpoch}.jpg');

                                try {
                                  await imagenRef.putFile(File(image.path));
                                  imgUrl = await imagenRef.getDownloadURL();
                                  print('Imagen subida exitosamente: $imgUrl');
                                } catch (e) {
                                  print('Error al subir la imagen: $e');
                                }
                              }
                              setState(() {});
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
                              'Foto de Perfil (Opcional)',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 210, 210, 210),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          // Si la imagen se ha subido con éxito, muestra un cuadro con la imagen
                          if (imgUrl != null && imgUrl!.isNotEmpty && imgUrl != '')
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(imgUrl!),
                            ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () async {
                              final ImagePicker picker = ImagePicker();
                              List<XFile>? images =
                                  await picker.pickMultiImage();

                              if (images != null) {
                                for (var image in images) {
                                  Reference imagenRef = storage.child(
                                      'images/${DateTime.now().millisecondsSinceEpoch}.jpg');

                                  try {
                                    await imagenRef.putFile(File(image.path));
                                    String imagesUrl =
                                        await imagenRef.getDownloadURL();
                                    print(
                                        'Imagen subida exitosamente: $imagesUrl');

                                    // Agrega la URL de la imagen a la lista de URLs de imágenes
                                    imagesUrls.add(imagesUrl);
                                  } catch (e) {
                                    print('Error al subir la imagen: $e');
                                  }
                                }
                              }
                              setState(() {});
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
                              'Otras Fotos (Opcional)',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 210, 210, 210),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Wrap(
                            spacing:
                                10, // Espacio horizontal entre las imágenes
                            runSpacing:
                                10, // Espacio vertical entre las imágenes
                            children: [
                              for (var imagesUrl in imagesUrls)
                                Stack(
                                  children: [
                                    Container(
                                      width: 100, // Ancho de la imagen
                                      height: 100, // Altura de la imagen
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(imagesUrl,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    Positioned(
                                      top: -10,
                                      right: -10,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color.fromARGB(
                                                        21, 75, 75, 75)
                                                    .withOpacity(0.2),
                                                spreadRadius: 1,
                                                blurRadius: 3,
                                                offset: Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                          child: IconButton(
                                            icon: Icon(Icons.close,
                                                color: const Color.fromARGB(
                                                    156, 244, 67, 54)),
                                            onPressed: () {
                                              setState(() {
                                                imagesUrls.remove(imagesUrl);
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                final data = {
                                  'Identificacion':
                                      identificacionController.text,
                                  'Peso': num.parse(pesoController.text),
                                  'Proposito': propositoController.text,
                                  'Raza': razaController.text,
                                  'Estado': saludController.text,
                                  'perfilV': imgUrl ?? '',
                                  'FechaNacimiento': Timestamp.fromDate(
                                      DateTime.parse(
                                          fechaNacimientoController.text)),
                                  'Sexo': sexoController.text,
                                  'Padre': padreController.text,
                                  'Madre': madreController.text,
                                  'Fotos': imagesUrls,
                                  'haciendaID': widget.haciendaID,
                                };
                                try {
                                  if (widget.bovinoID != null &&
                                      widget.bovinoID!.isNotEmpty) {
                                    await instance
                                        .collection('Bovinos')
                                        .doc(widget.bovinoID)
                                        .update(data);
                                  } else {
                                  await instance
                                      .collection('Bovinos')
                                      .add(data);
                                  }
                                } catch (e) {
                                  print('Error al guardar el bovino: $e');
                                }

                                ScaffoldMessenger.of(context)
                                    .showSnackBar( SnackBar(
                                  content:
                        
                                      Text(widget.bovinoID != null && widget.bovinoID!.isNotEmpty ? "Bovino actualizado correctamente" : "Bovino agregado correctamente",),
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
                            
                            child: Text(
                              widget.bovinoID != null && widget.bovinoID!.isNotEmpty ? "Guardar" : "Agregar",
                              style: const TextStyle(
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
            )));
  }
}
