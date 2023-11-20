import 'package:ct484_project/models/diary.dart';
import 'package:ct484_project/ui/diary/edit.diary.screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DiaryCard extends StatelessWidget {
  final Diary diary;
  final VoidCallback? onTriggerRebuild;
  const DiaryCard({required this.diary, this.onTriggerRebuild, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat.yMMMMd().format(diary.dateTime),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, // for bold
                    fontSize: 18.0, // for font size
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await Navigator.of(context).pushNamed(
                      EditDiaryScreen.routeName,
                      arguments: diary.dateTime,
                    );
                    // setState(() {});
                    onTriggerRebuild?.call();
                  },
                  icon: const Icon(Icons.edit),
                )
              ],
            ),
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
