import 'package:ct484_project/models/diary.dart';
import 'package:ct484_project/ui/auth/auth.manager.dart';
import 'package:ct484_project/ui/auth/auth.screen.dart';
import 'package:ct484_project/ui/auth/values/auth.theme.dart';
import 'package:ct484_project/ui/calendar/calendar.screen.dart';
import 'package:ct484_project/ui/diary/diary.manager.dart';
import 'package:ct484_project/ui/diary/edit.diary.screen.dart';
import 'package:ct484_project/ui/diary/diary.screen.dart';
import 'package:ct484_project/ui/profile/profile.screen.dart';
import 'package:ct484_project/ui/shared/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthManager(),
        ),
        ChangeNotifierProxyProvider<AuthManager, DiariesManager>(
          create: (ctx) => DiariesManager(),
          update: (ctx, authManager, diariesManager) {
            diariesManager!.authToken = authManager.authToken;
            return diariesManager;
          },
        ),
      ],
      child: Consumer<AuthManager>(
        builder: (context, authManager, child) {
          return MaterialApp(
            title: 'Diary',
            debugShowCheckedModeBanner: false,
            home: authManager.isAuth
                ? const CalendarScreen()
                : FutureBuilder(
                    future: authManager.tryAutoLogin(),
                    builder: (ctx, snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthScreen();
                    },
                  ),
            routes: {
              AuthScreen.routeName: (ctx) => const AuthScreen(),
              CalendarScreen.routeName: (ctx) => const CalendarScreen(),
              DiaryScreen.routeName: (ctx) => const DiaryScreen(),
              // EditDiaryScreen.routeName: (ctx) => const EditDiaryScreen(),
              ProfileScreen.routeName: (ctx) => const ProfileScreen(),
            },
            onGenerateRoute: (settings) {
              if (settings.name == EditDiaryScreen.routeName) {
                DateTime dateTime = settings.arguments as DateTime;
                Diary diary =
                    context.read<DiariesManager>().findByDateTime(dateTime) ??
                        Diary(dateTime: dateTime, content: '');
                return MaterialPageRoute(
                  builder: (ctx) {
                    return EditDiaryScreen(diary: diary);
                  },
                );
              }
              return null;
            },
          );
        },
      ),
    );
  }
}
