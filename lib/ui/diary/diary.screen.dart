import 'dart:developer';

import 'package:ct484_project/models/diary.dart';
import 'package:ct484_project/ui/diary/diary.manager.dart';
import 'package:ct484_project/ui/shared/AppBottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DiaryScreen extends StatefulWidget {
  static const routeName = '/diary';
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const AppBottomNavigationBar(),
      body: FutureBuilder(
        future: context.read<DiariesManager>().fetchDiaries(true),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return RefreshIndicator(
            onRefresh: () => context.read<DiariesManager>().fetchDiaries(true),
            child: Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                Expanded(child: buildDiariesListView(context)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildDiariesListView(BuildContext context) {
    return Consumer<DiariesManager>(
      builder: (ctx, diariesManager, child) {
        print(diariesManager.itemCount);
        return ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: diariesManager.itemCount,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: buildDiaryCard(context, diariesManager.items[index]),
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        );
      },
    );
  }

  Widget buildDiaryCard(BuildContext context, Diary diary) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat.yMMMMd().format(diary.dateTime)),
            const SizedBox(
              height: 6,
            ),
            Text(diary.content),
          ],
        ),
      ),
    );
  }
}
