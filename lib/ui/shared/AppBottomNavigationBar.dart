import 'package:ct484_project/ui/calendar/calendar.screen.dart';
import 'package:ct484_project/ui/diary/diary.screen.dart';
import 'package:ct484_project/ui/profile/profile.screen.dart';
import 'package:flutter/material.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> appRouteNames = [
      CalendarScreen.routeName,
      DiaryScreen.routeName,
      ProfileScreen.routeName,
    ];

    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Diary',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      selectedItemColor: Colors.grey[600],
      unselectedItemColor: Colors.grey[600],
      onTap: (int index) {
        Navigator.of(context).pushReplacementNamed(appRouteNames[index]);
      },
    );
  }
}
