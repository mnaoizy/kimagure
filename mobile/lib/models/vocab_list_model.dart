import 'package:flutter/material.dart';
import '../gen/proto/chinese/v1/chinese.pb.dart';
import '../gen/proto/chinese/v1/chinese.connect.client.dart';
import '../api/transport.dart';

class VocabListModel extends ChangeNotifier {
  final ChineseServiceClient _client = ChineseServiceClient(transport);
  List<ChineseItem> vocabItems = [];
  bool isLoading = false;
  String? error;
  String? lessonId;

  Future<void> fetchVocabList(String lessonId) async {
    if (lessonId.isEmpty) return;
    this.lessonId = lessonId;
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await _client.getChineseList(
        GetChineseListRequest(lessonId: lessonId),
      );
      vocabItems = response.items;
    } catch (e) {
      error = '単語リストの取得に失敗しました';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
