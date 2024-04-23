import 'package:flutter/material.dart';
import 'package:descendencia/routes.dart';
import 'package:horizontal_calendar/horizontal_calendar.dart';

class InicioPageComp extends StatelessWidget {
  const InicioPageComp({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hacienda'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 5, 93, 24),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HorizontalCalendar(
                date: DateTime.now(),
                initialDate: DateTime.now(),
                textColor: Colors.black,
                backgroundColor: Colors.white,
                selectedColor: Colors.orange,
                showMonth: true,
                locale: Localizations.localeOf(context),
                onDateSelected: (date) {
                  // if (kDebugMode) {
                  //   print(date.toString());
                  // }
                },
              ),
              const SizedBox(height: 50.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, MyRoutes.calendar.name);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  backgroundColor: const Color.fromARGB(255, 5, 93, 24),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10.0),
                    Image.asset(
                      'assets/calendario.png',
                      width: 100, // Adjust the width of the image
                      height: 100, // Adjust the height of the image
                    ),
                    const SizedBox(height: 10.0),
                    const Text('Actividades'),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, MyRoutes.general.name);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  backgroundColor: const Color.fromARGB(255, 5, 93, 24),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10.0),
                    Image.asset(
                      'assets/general.png',
                      width: 100, // Adjust the width of the image
                      height: 70, // Adjust the height of the image
                    ),
                    const SizedBox(height: 10.0),
                    const Text('Datos Generales'),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
