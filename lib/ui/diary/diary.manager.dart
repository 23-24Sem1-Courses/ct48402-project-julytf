import 'dart:developer';

import 'package:ct484_project/models/auth_token.dart';
import 'package:ct484_project/models/diary.dart';
import 'package:ct484_project/services/diaries.service.dart';
import 'package:flutter/foundation.dart';

class DiariesManager with ChangeNotifier {
  List<Diary> _items = [];
  final DiariesService _diariesService;

  DiariesManager([AuthToken? authToken])
      : _diariesService = DiariesService(authToken);

  set authToken(AuthToken? authToken) {
    _diariesService.authToken = authToken;
  }

  Future<void> fetchDiaries([bool filterByUser = false]) async {
    _items = await _diariesService.fetchDiaries(filterByUser);
    // log(_items.length.toString());
    notifyListeners();
  }

  Future<void> addDiary(Diary diary) async {
    final newDiary = await _diariesService.addDiary(diary);
    if (newDiary != null) {
      _items.add(newDiary);
      notifyListeners();
    }
  }

  int get itemCount {
    return _items.length;
  }

  List<Diary> get items {
    return [..._items];
  }

  Diary? findById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (error) {
      return null;
    }
  }

  Diary? findByDateTime(DateTime dateTime) {
    try {
      return _items.firstWhere((item) => item.dateTime == dateTime);
    } catch (error) {
      return null;
    }
  }

  List<Diary>? findByMonthAndYear(DateTime dateTime) {
    try {
      return _items
          .where((item) =>
              item.dateTime.month == dateTime.month &&
              item.dateTime.year == dateTime.year)
          .toList();
    } catch (error) {
      return null;
    }
  }

  Future<void> updateDiary(Diary diary) async {
    final index = _items.indexWhere((item) => item.id == diary.id);
    if (index >= 0) {
      if (await _diariesService.updateDiary(diary)) {
        _items[index] = diary;
        notifyListeners();
      }
    }
  }

  Future<void> deleteDiary(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    Diary? existingDiary = _items[index];
    _items.removeAt(index);
    notifyListeners();
    if (!await _diariesService.deleteDiary(id)) {
      _items.insert(index, existingDiary);
      notifyListeners();
    }
  }
}
