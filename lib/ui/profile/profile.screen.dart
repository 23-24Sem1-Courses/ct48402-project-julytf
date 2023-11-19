import 'package:ct484_project/ui/auth/auth.manager.dart';
import 'package:ct484_project/ui/auth/auth.screen.dart';
import 'package:ct484_project/ui/calendar/calendar.screen.dart';
import 'package:ct484_project/ui/diary/diary.screen.dart';
import 'package:ct484_project/ui/shared/AppBottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AppBottomNavigationBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Current account:',
              style: TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 16.0),
            Text(
              context.read<AuthManager>().currentEmail,
              style: const TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(AuthScreen.routeName);
                context.read<AuthManager>().logout;
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
