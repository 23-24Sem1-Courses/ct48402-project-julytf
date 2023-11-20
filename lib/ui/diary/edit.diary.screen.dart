import 'package:ct484_project/models/diary.dart';
import 'package:ct484_project/ui/diary/diary.manager.dart';
import 'package:ct484_project/ui/shared/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditDiaryScreen extends StatefulWidget {
  static const routeName = '/diary/edit';
  final Diary diary;

  const EditDiaryScreen({
    super.key,
    required this.diary,
  });

  @override
  State<EditDiaryScreen> createState() => _EditDiaryScreenState();
}

class _EditDiaryScreenState extends State<EditDiaryScreen> {
  late Diary _editedDiary;

  late TextEditingController contentController;

  Future<void> _onSave() async {
    try {
      DiariesManager diariesManager = context.read<DiariesManager>();
      if (contentController.text.isEmpty) {
        Navigator.of(context).pop();
        return;
      }
      ;
      _editedDiary.content = contentController.text;
      if (_editedDiary.id != null) {
        await diariesManager.updateDiary(_editedDiary);
      } else {
        await diariesManager.addDiary(_editedDiary);
      }
    } catch (error) {
      if (mounted) {
        await showErrorDialog(context, 'Something went wrong.');
      }
    }
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    _editedDiary = widget.diary;
    contentController = TextEditingController(text: _editedDiary.content);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          DateFormat.yMMMMd().format(_editedDiary.dateTime),
          style: TextStyle(color: Colors.blue[300]),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.blue[300],
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: contentController,
                maxLines: null,
                textAlignVertical: TextAlignVertical.top,
                expands: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your text here',
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _onSave,
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
