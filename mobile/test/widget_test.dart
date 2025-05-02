// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mobile/gen/proto/chinese/v1/chinese.pb.dart';
import 'package:provider/provider.dart';
import 'package:mobile/app.dart';
import 'package:mobile/models/lesson_list_model.dart';

class MockLessonListModel extends LessonListModel {
  MockLessonListModel() {
    lessons = [
      Lesson(
        id: '1',
        title: 'Lesson 1',
        description: 'Description for Lesson 1',
      ),
    ];
    isLoading = false;
    error = null;
  }
  @override
  Future<void> fetchLessons() async {
    // Do nothing
  }
}

void main() {
  testWidgets('App renders correctly', (WidgetTester tester) async {
    // Inject the mock model to avoid async/timer issues
    await tester.pumpWidget(
      ChineseVocabApp(
        providers: [
          ChangeNotifierProvider<LessonListModel>(
            create: (_) => MockLessonListModel(),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    // Verify the app title is shown
    expect(find.text('Lesson 1'), findsOneWidget);
  });
}
