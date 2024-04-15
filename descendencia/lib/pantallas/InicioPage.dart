import 'package:flutter/material.dart';
// componentes de la pantalla de inicio
import 'package:descendencia/pantallas/components/inicio_page.dart';
import 'package:descendencia/pantallas/components/produccion_page.dart';
import 'package:descendencia/pantallas/components/ajustes_page.dart';
import 'package:flutter/widgets.dart';
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
          // se bloquea el scroll
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (value) {
            widget.currentIndex = value;
            setState(() {});
          },
          children: const [
            // Componentes de la pantalla de inicio
            InicioPageComp(),
            ProduccionPage(),
            AjustesPage()
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
            icon: Image.asset('assets/hacienda.png', width: 35, height: 35),
            label: 'Hacienda',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/produccion.png', width: 35, height: 35),
            label: 'Producción',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/ajuste.png', width: 35, height: 35),
            label: 'Ajustes',
          ),
        ],
        // color de los iconos de la barra de navegación
        selectedItemColor: const Color.fromARGB(255, 0, 55, 16),
        backgroundColor: const Color.fromARGB(185, 0, 93, 20)
      ),
    );
  }
}
