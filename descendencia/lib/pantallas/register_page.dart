import 'package:descendencia/routes.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({required key}) : super(key: key);

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordconfirmController = TextEditingController();

  bool isPasswordVisible = false;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                      maxLength: 20,
                      validator: (value) {
                        if (value!.isEmpty) return 'El nombre es obligatorio';

                        if (value.length < 3)
                          return 'El nombre debe tener al menos 3 caracteres';

                        return null;
                      },
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                        icon: Icon(
                          Icons.person,
                          color: Color.fromARGB(255, 5, 93, 24),
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextFormField(
                      controller: emailController,
                      maxLength: 25,
                      validator: (value) {
                        if (value!.isEmpty) return 'El correo es obligatorio';

                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        icon: Icon(
                          Icons.email,
                          color: Color.fromARGB(255, 5, 93, 24),
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextFormField(
                      controller: phoneController,
                      maxLength: 20,
                      validator: (value) {
                        if (value!.isEmpty) return 'El teléfono es obligatorio';

                        return null;
                      },
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Teléfono',
                        icon: Icon(
                          Icons.phone,
                          color: Color.fromARGB(255, 5, 93, 24),
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextFormField(
                      controller: passwordController,
                      maxLength: 25,
                      obscureText: !isPasswordVisible,
                      validator: (value) {
                        if (value!.isEmpty)
                          return 'La contraseña es obligatoria';

                        return null;
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
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
                    TextFormField(
                      controller: passwordconfirmController,
                      maxLength: 25,
                      obscureText: !isPasswordVisible,
                      validator: (value) {
                        if (value!.isEmpty)
                          return 'La confirmación de contraseña es obligatoria';

                        return null;
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
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
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          print('Formulario válido');

                          String nombre = nameController.text;
                          String email = emailController.text;
                          String telefono = phoneController.text;
                          String contra = passwordController.text;
                          String concontra = passwordconfirmController.text;
                          if (contra == concontra) {
                            print('Nombre: $nombre');
                            print('Email: $email');
                            print('Teléfono: $telefono');
                            print('Contraseña: $contra');
                            print('Confirmación de contraseña: $concontra');

                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Registro completado')));

                            Navigator.pushReplacementNamed(
                                context, MyRoutes.loginroute.name);
                            return;
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                  'La contraseña no coincide con la confirmación de la misma'),
                              backgroundColor: Color.fromARGB(255, 5, 93, 24),
                            ));
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
