import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:descendencia/routes.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordconfirmController = TextEditingController();

  final instance = FirebaseFirestore.instance;
  bool isPasswordVisible = false;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as String?;

    if (args != null) {
      instance.collection('usuarios').doc(args).get().then((value) {
        nameController.text = value['nombre'];
        emailController.text = value['correo'];
        phoneController.text = value['telefono'].toString();
        passwordController.text = value['contraseña'];
        passwordconfirmController.text = value['confcontra'];
      });
    }
    return Scaffold(
      appBar: AppBar(
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        backgroundColor: const Color.fromARGB(255, 5, 93, 24),
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/logo1.png',
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 20),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value!.isEmpty) return 'El nombre es obligatorio';

                        if (value.length < 3) return 'El nombre debe tener al menos 3 caracteres';

                        return null;
                      },
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        errorMaxLines: 2,
                        labelText: 'Nombre',
                        icon: Icon(
                          Icons.person,
                          color: Color.fromARGB(255, 5, 93, 24),
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 25),
                    TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value!.isEmpty) return 'El correo es obligatorio';

                        Pattern pattern =
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        RegExp regex = RegExp(pattern.toString());

                        if (!regex.hasMatch(value)) return 'Ejemplos de correos válidos: ejemplo@dominio.com o nombre.apellido@empresa.org';

                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        errorMaxLines: 2,
                        labelText: 'Email',
                        icon: Icon(
                          Icons.email,
                          color: Color.fromARGB(255, 5, 93, 24),
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 25),
                    TextFormField(
                      controller: phoneController,
                      validator: (value) {
                        if (value!.isEmpty) return 'El teléfono es obligatorio';

                        Pattern pattern = r'^(\+?\d{1,4}?)?((\(\d{1,3}\))|\d{1,3})[- .]?\d{1,4}[- .]?\d{1,9}$';
                        RegExp regex = RegExp(pattern.toString());

                        if (!regex.hasMatch(value)) return 'Introduce un número de teléfono válido';

                        return null;
                      },
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        errorMaxLines: 2,
                        labelText: 'Teléfono',
                        icon: Icon(
                          Icons.phone,
                          color: Color.fromARGB(255, 5, 93, 24),
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 25),
                    TextFormField(
                      controller: passwordController,
                      obscureText: !isPasswordVisible,
                      validator: (value) {
                        if (value!.isEmpty) return 'La contraseña es obligatoria';
                        if (value.length < 8) return 'La contraseña debe tener al menos 8 caracteres';
                        if (!RegExp(r'[a-z]').hasMatch(value)) return 'La contraseña debe contener al menos una letra minúscula';
                        if (!RegExp(r'[A-Z]').hasMatch(value)) return 'La contraseña debe contener al menos una letra mayúscula';
                        if (!RegExp(r'[0-9]').hasMatch(value)) return 'La contraseña debe contener al menos un número';
                        if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) return 'La contraseña debe contener al menos un caracter especial';

                        return null;
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        errorMaxLines: 2,
                        labelText: 'Contraseña',
                        icon: const Icon(
                          Icons.lock,
                          color: Color.fromARGB(255, 5, 93, 24),
                        ),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    TextFormField(
                      controller: passwordconfirmController,
                      obscureText: !isPasswordVisible,
                      validator: (value) {
                        if (value!.isEmpty) return 'La confirmación de contraseña es obligatoria';

                        if(passwordController.text != value) return 'Las contraseñas no coinciden';

                        return null;
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        errorMaxLines: 2,
                        labelText: 'Confirmar contraseña',
                        icon: const Icon(
                          Icons.lock,
                          color: Color.fromARGB(255, 5, 93, 24),
                        ),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
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
                          print('Formulario válido');

                          String nombre = nameController.text;
                          String email = emailController.text;
                          String telefono = phoneController.text;
                          String contra = passwordController.text;
                          String concontra = passwordconfirmController.text;
                          if (contra == concontra) {
                            try {
                              final instance = FirebaseFirestore.instance;
                              final docRef = instance.collection('usuarios').doc();

                              final data = {
                                'nombre': nombre,
                                'email': email,
                                'telefono': telefono,
                                'contraseña': contra,
                                'confcontra': concontra,
                                'userID': docRef.id,
                              };

                              ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Registro completado')));

                              Navigator.pushReplacementNamed(
                                  context, MyRoutes.general.name, arguments: docRef.id);

                              // Agrega los datos al documento
                              await docRef.set(data);
                            } catch (e) {
                              print('Error al registrar el usuario: $e');
                            }

                            return;
                          } 
                        }
                      },
                      child: const Text('Registrate'),
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
