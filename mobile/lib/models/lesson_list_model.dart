import 'package:flutter/material.dart';
import '../gen/proto/chinese/v1/chinese.pb.dart';
import '../gen/proto/chinese/v1/chinese.connect.client.dart';
import '../api/transport.dart';

class LessonListModel extends ChangeNotifier {
  final ChineseServiceClient _client = ChineseServiceClient(transport);
  List<Lesson> lessons = [];
  bool isLoading = false;
  String? error;

  LessonListModel() {
    fetchLessons();
  }

  Future<void> fetchLessons() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await _client.getLessons(GetLessonsRequest());
      lessons = response.lessons;
    } catch (e) {
      print(e);
      error = 'レッスンリストの取得に失敗しました: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
