import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:descendencia/routes.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:descendencia/pantallas/components/model/event.dart';
import 'package:descendencia/pantallas/components/screens/bovino_screen.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class InicioPageComp extends StatefulWidget {
  const InicioPageComp({super.key});

  @override
  State<InicioPageComp> createState() => _InicioPageCompState();
}

class _InicioPageCompState extends State<InicioPageComp> {
  String qrValue = '';

  void scanQr() async {
    String? cameraScanResult = await scanner.scan();

    if (cameraScanResult != null) {
      setState(() {
        qrValue = cameraScanResult;
      });
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BovinoScreen(
          bovinoID: qrValue,
        ),
      ),
    );

    // Navigator.pushNamed(context, MyRoutes.qr.name);
  }

  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late DateTime _selectedDay;
  late CalendarFormat _calendarFormat;
  late Map<DateTime, List<Event>> _events;
  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState() {
    super.initState();
    _events = LinkedHashMap(
      equals: isSameDay,
      hashCode: getHashCode,
    );
    _focusedDay = DateTime.now();
    _firstDay = DateTime.now().subtract(const Duration(days: 5000));
    _lastDay = DateTime.now().add(const Duration(days: 5000));
    _selectedDay = DateTime.now();
    _calendarFormat = CalendarFormat.week;
    _loadFirestoreEvents();
  }

  _loadFirestoreEvents() async {
    final firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    _events = {};

    final snap = await FirebaseFirestore.instance
        .collection('events')
        .where('date', isGreaterThanOrEqualTo: firstDay)
        .where('date', isLessThanOrEqualTo: lastDay)
        .withConverter(
            fromFirestore: Event.fromFirestore,
            toFirestore: (event, options) => event.toFirestore())
        .get();
    for (var doc in snap.docs) {
      final event = doc.data();
      final day =
          DateTime.utc(event.date.year, event.date.month, event.date.day);
      if (_events[day] == null) {
        _events[day] = [];
      }
      _events[day]!.add(event);
    }
    setState(() {});
  }

  List<Event> _getEventsForTheDay(DateTime day) {
    return _events[day] ?? [];
  }

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
              TableCalendar(
                eventLoader: _getEventsForTheDay,
                calendarFormat: _calendarFormat,
                startingDayOfWeek: StartingDayOfWeek.monday,
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                focusedDay: _focusedDay,
                firstDay: _firstDay,
                lastDay: _lastDay,
                onPageChanged: (focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                  });
                  _loadFirestoreEvents();
                },
                selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                onDaySelected: (selectedDay, focusedDay) {
                  print(_events[selectedDay]);
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                availableGestures: AvailableGestures.all,
                headerStyle: const HeaderStyle(
                  titleTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color.fromARGB(255, 5, 93, 24),
                  ),
                  formatButtonVisible: false,
                  titleCentered: true,
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: Color.fromARGB(255, 5, 93, 24),
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    size: 16,
                    color: Color.fromARGB(255, 5, 93, 24),
                  ),
                ),
                calendarStyle: const CalendarStyle(
                  weekendTextStyle: TextStyle(
                    color: Color.fromARGB(255, 5, 93, 24),
                  ),
                  selectedDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 5, 93, 24),
                  ),
                ),
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
              ElevatedButton(
                onPressed: () {
                  // Navigator.pushNamed(context, MyRoutes.salud.name);
                  setState(() {
                    scanQr();
                  });
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
                child: const Column(
                  children: [
                    SizedBox(height: 10.0),
                    Icon(Icons.qr_code, size: 80),
                    SizedBox(height: 10.0),
                    Text('Escanear QR'),
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
