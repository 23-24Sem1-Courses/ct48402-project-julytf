import 'dart:convert';
import 'package:ct484_project/models/diary.dart';
import 'package:http/http.dart' as http;
import '../models/auth_token.dart';
import 'firebase.service.dart';
import 'dart:developer';

class DiariesService extends FirebaseService {
  DiariesService([AuthToken? authToken]) : super(authToken);

  Future<List<Diary>> fetchDiaries([bool filterByUser = false]) async {
    List<Diary> diaries = [];
    try {
      final filters =
          filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
      final diariesUrl =
          Uri.parse('$databaseUrl/diaries.json?auth=$token&$filters');
      // log(diariesUrl.toString());
      final response = await http.get(diariesUrl);
      final diariesMap = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 200) {
        print(diariesMap['error']);
        return diaries;
      }
      diaries = diariesMap.entries
          .map((entry) => Diary.fromJson({
                'id': entry.key,
                ...entry.value,
              }))
          .toList();
      return diaries;
    } catch (error) {
      print(error);
      return diaries;
    }
  }

  Future<Diary?> addDiary(Diary dairy) async {
    try {
      final url = Uri.parse('$databaseUrl/diaries.json?auth=$token');
      final response = await http.post(
        url,
        body: json.encode(
          dairy.toJson()
            ..addAll({
              'creatorId': userId,
            }),
        ),
      );
      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }
      return dairy.copyWith(
        id: json.decode(response.body)['name'],
      );
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<bool> updateDiary(Diary dairy) async {
    try {
      final url =
          Uri.parse('$databaseUrl/diaries/${dairy.id}.json?auth=$token');
      final response = await http.patch(
        url,
        body: json.encode(dairy.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> deleteDiary(String id) async {
    try {
      final url = Uri.parse('$databaseUrl/diaries/$id.json?auth=$token');
      final response = await http.delete(url);
      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}
