import 'package:flutter/material.dart';

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
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      body: PageView(
          controller: pageController,
          // se bloquea el scroll
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (value) {
            widget.currentIndex = value;
            setState(() {});
          },
          children: const [
            Padding(
              padding: EdgeInsets.all(20),
              child: Card(
                elevation: 10,
                child: Center(
                  child: Text(
                    'joseph.alcerro@unah.hn',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Card(
                elevation: 10,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Melvin Majano",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text("Joseph Alcerro", style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ),
            )
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Creditos',
          ),
        ],
      ),
    );
  }
}
