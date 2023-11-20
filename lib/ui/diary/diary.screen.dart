import 'dart:developer';

import 'package:ct484_project/models/diary.dart';
import 'package:ct484_project/ui/diary/diary.manager.dart';
import 'package:ct484_project/ui/diary/edit.diary.screen.dart';
import 'package:ct484_project/ui/shared/AppBottomNavigationBar.dart';
import 'package:ct484_project/ui/shared/DiaryCard.dart';
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
                  height: 24,
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
              child: DiaryCard(
                diary: diariesManager.items[index],
                onTriggerRebuild: () {
                  setState(() {});
                },
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        );
      },
    );
  }

  // Widget buildDiaryCard(BuildContext context, Diary diary) {
  //   return Container(
  //     decoration: BoxDecoration(
  //         border: Border.all(),
  //         borderRadius: const BorderRadius.all(Radius.circular(10))),
  //     child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 DateFormat.yMMMMd().format(diary.dateTime),
  //                 style: const TextStyle(
  //                   fontWeight: FontWeight.bold, // for bold
  //                   fontSize: 18.0, // for font size
  //                 ),
  //               ),
  //               IconButton(
  //                 onPressed: () async {
  //                   await Navigator.of(context).pushNamed(
  //                     EditDiaryScreen.routeName,
  //                     arguments: diary.dateTime,
  //                   );
  //                   setState(() {});
  //                 },
  //                 icon: const Icon(Icons.edit),
  //               )
  //             ],
  //           ),
  //           const SizedBox(
  //             height: 6,
  //           ),
  //           Text(diary.content),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
