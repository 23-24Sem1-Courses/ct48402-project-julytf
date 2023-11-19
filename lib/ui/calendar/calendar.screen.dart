import 'dart:math';

import 'package:ct484_project/ui/calendar/calendar.screen.dart';
import 'package:ct484_project/ui/diary/diary.manager.dart';
import 'package:ct484_project/ui/diary/edit.diary.screen.dart';
import 'package:ct484_project/ui/diary/diary.screen.dart';
import 'package:ct484_project/ui/profile/profile.screen.dart';
import 'package:ct484_project/ui/shared/AppBottomNavigationBar.dart';
import 'package:ct484_project/ui/shared/MonthPicker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CalendarScreen extends StatefulWidget {
  static const routeName = '/calendar';
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const AppBottomNavigationBar(),
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Center(
            child: TextButton(
              onPressed: () async {
                selectedDate = await showMonthPicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000, 5),
                      lastDate: DateTime(2050),
                    ) ??
                    DateTime.now();
                print(selectedDate);
                setState(() {});
              },
              child: Text(
                DateFormat.yMMMM().format(selectedDate),
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('Mon'),
              Text('Tue'),
              Text('Wed'),
              Text('Thu'),
              Text('Fri'),
              Text('Sat'),
              Text('Sun'),
            ],
          ),
          FutureBuilder(
            future: context.read<DiariesManager>().fetchDiaries(true),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return RefreshIndicator(
                onRefresh: () =>
                    context.read<DiariesManager>().fetchDiaries(true),
                child: Expanded(child: buildCalendar(context)),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildCalendar(BuildContext context) {
    final existedDiaries =
        context.read<DiariesManager>().findByMonthAndYear(selectedDate);

    final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    final offset = (firstDayOfMonth.weekday - 1) % 7;

    final totalDaysInMonth =
        DateTime(selectedDate.year, selectedDate.month + 1, 0).day;

    return SizedBox(
      height: 400.0,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
        ),
        itemCount: totalDaysInMonth + offset,
        itemBuilder: (context, index) {
          if (index < offset) {
            return Container();
          }
          print('---');
          print(index);
          print(existedDiaries?.indexWhere(
              (diary) => diary.dateTime.day == (index - offset + 1)));
          print(existedDiaries?.indexWhere(
                  (diary) => diary.dateTime.day == (index - offset + 1)) !=
              -1);
          print('---');
          return Center(
            child: Container(
              width: 45.0,
              height: 45.0,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: existedDiaries?.indexWhere((diary) =>
                            diary.dateTime.day == (index - offset + 1)) !=
                        -1
                    ? Colors.blue[300]
                    : null,
                border: Border.all(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              child: GestureDetector(
                onTap: () async {
                  await Navigator.of(context).pushNamed(
                    EditDiaryScreen.routeName,
                    arguments: DateTime(selectedDate.year, selectedDate.month,
                        index - offset + 1),
                  );
                  setState(() {});
                },
                child: Center(
                  child: Text(
                    (index - offset + 1).toString(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
