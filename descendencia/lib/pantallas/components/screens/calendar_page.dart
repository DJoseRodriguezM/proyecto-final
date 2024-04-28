import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:descendencia/pantallas/components/screens/edit_event.dart';
import 'package:flutter/widgets.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/event.dart';
import '../widgets/event_item.dart';
import 'add_event.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
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
    _calendarFormat = CalendarFormat.month;
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
        title: const Text('Actividades'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 5, 93, 24),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
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
            ..._getEventsForTheDay(_selectedDay).map(
              (event) => EventItem(
                  event: event,
                  onTap: () async {
                    final res = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditEvent(
                            firstDate: _firstDay,
                            lastDate: _lastDay,
                            event: event),
                      ),
                    );
                    if (res ?? false) {
                      _loadFirestoreEvents();
                    }
                  },
                  onDelete: () async {
                    final delete = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Eliminar Actividad"),
                        content: const Text("Esta seguro que desea eliminar la actividad?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black,
                            ),
                            child: const Text("No"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  const Color.fromARGB(255, 5, 93, 24),
                            ),
                            child: const Text("Si"),
                          ),
                        ],
                      ),
                    );
                    if (delete ?? false) {
                      await FirebaseFirestore.instance
                          .collection('events')
                          .doc(event.id)
                          .delete();
                      _loadFirestoreEvents();
                    }
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => AddEvent(
                firstDate: _firstDay,
                lastDate: _lastDay,
                selectedDate: _selectedDay,
              ),
            ),
          );
          if (result ?? false) {
            _loadFirestoreEvents();
          }
        },
        backgroundColor: const Color.fromARGB(255, 5, 93, 24),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
