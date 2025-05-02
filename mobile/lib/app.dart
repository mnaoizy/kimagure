import 'package:flutter/material.dart';
import 'package:mobile/models/auth_model.dart';
import 'package:provider/provider.dart';
import 'models/lesson_list_model.dart';
import 'models/vocab_list_model.dart';
import 'models/vocab_detail_model.dart';
import 'screens/lesson_list_screen.dart';
import 'screens/vocab_list_screen.dart';
import 'package:provider/single_child_widget.dart';

class ChineseVocabApp extends StatelessWidget {
  final List<SingleChildWidget>? providers;
  const ChineseVocabApp({super.key, this.providers});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:
          providers ??
          [
            ChangeNotifierProvider(create: (_) => LessonListModel()),
            ChangeNotifierProvider(create: (_) => VocabListModel()),
            ChangeNotifierProvider(create: (_) => VocabDetailModel()),
            ChangeNotifierProvider(create: (_) => AuthModel()),
          ],
      child: MaterialApp(
        title: '中国語単語帳',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: const LessonListScreen(),
        routes: {'/vocab': (context) => const VocabListScreen()},
      ),
    );
  }
}
