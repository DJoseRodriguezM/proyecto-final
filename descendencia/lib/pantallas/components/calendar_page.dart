
import 'package:flutter/material.dart';
import 'package:horizontal_calendar/horizontal_calendar.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actividades'),
        actions: <Widget>[
          PopupMenuButton<Locale>(
            // onSelected: widget.onLocaleChanged,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
              const PopupMenuItem<Locale>(
                value: Locale('en', ''),
                child: Text('English'),
              ),
              const PopupMenuItem<Locale>(
                value: Locale('fr', ''),
                child: Text('French'),
              ),
              const PopupMenuItem<Locale>(
                value: Locale('es', ''),
                child: Text('Spanish'),
              ),
              const PopupMenuItem<Locale>(
                value: Locale('vi', ''),
                child: Text('Vietnamese'),
              ),
              const PopupMenuItem<Locale>(
                value: Locale('zh', ''),
                child: Text('Chinese'),
              ),
            ],
          ),
        ],
      ),
      body: HorizontalCalendar(
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
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({super.key, required this.text, this.onPressed});

  final String text;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
