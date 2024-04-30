import 'package:flutter/material.dart';
// componentes de la pantalla de inicio
import 'package:descendencia/pantallas/components/inicio_page.dart';
import 'package:descendencia/pantallas/components/produccion_page.dart';
import 'package:descendencia/pantallas/components/ajustes_page.dart';
import 'package:descendencia/pantallas/components/tratamientos_page.dart';

class InicioPage extends StatefulWidget {
  InicioPage({Key? key, this.currentIndex = 0}) : super(key: key);

  int currentIndex;
  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
          controller: pageController,
          onPageChanged: (value) {
            widget.currentIndex = value;
            setState(() {});
          },
          children: [
            InicioPageComp(),
            const ProduccionPage(),
            const TratamientosPage(),
            const AjustesPage(),
          ]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: (index) {
          widget.currentIndex = index;

          pageController.animateToPage(
            index,
            curve: Curves.easeIn,
            duration: const Duration(milliseconds: 300),
          );
          setState(() {});
        },
        items: [
          BottomNavigationBarItem(
            backgroundColor: const Color.fromARGB(255, 5, 93, 24),
            icon: Image.asset('assets/hacienda.png', width: 35, height: 35),
            label: 'Hacienda',
          ),
          BottomNavigationBarItem(
            backgroundColor: const Color.fromARGB(255, 5, 93, 24),
            icon: Image.asset('assets/produccion.png', width: 35, height: 35),
            label: 'Producción',
          ),
          BottomNavigationBarItem(
            backgroundColor: const Color.fromARGB(255, 5, 93, 24),
            icon: Image.asset('assets/tratamiento.png', width: 35, height: 35),
            label: 'Tratamientos',
          ),
          BottomNavigationBarItem(
            backgroundColor: const Color.fromARGB(255, 5, 93, 24),
            icon: Image.asset('assets/ajuste.png', width: 35, height: 35),
            label: 'Ajustes',
          ),
        ],
        selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
      ),
    );
  }
}
