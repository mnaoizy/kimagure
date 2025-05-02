import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/lesson_list_model.dart';
import '../models/auth_model.dart';

class LessonListScreen extends StatefulWidget {
  const LessonListScreen({super.key});

  @override
  State<LessonListScreen> createState() => _LessonListScreenState();
}

class _LessonListScreenState extends State<LessonListScreen> {
  bool _calledAuth = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_calledAuth) {
      _calledAuth = true;
      // 1度だけ認証
      Future.microtask(
        () => context.read<AuthModel>().authenticateAnonymously(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('レッスン一覧'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<LessonListModel>().fetchLessons(),
          ),
        ],
      ),
      body: Consumer<LessonListModel>(
        builder: (context, model, _) {
          if (model.isLoading) {
            return const Center(child: CupertinoActivityIndicator());
          }
          if (model.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(model.error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => model.fetchLessons(),
                    child: const Text('再試行'),
                  ),
                ],
              ),
            );
          }
          if (model.lessons.isEmpty) {
            return const Center(child: Text('レッスンが登録されていません'));
          }
          return ListView.builder(
            itemCount: model.lessons.length,
            itemBuilder: (context, index) {
              final lesson = model.lessons[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(lesson.title),
                  subtitle: Text(lesson.description),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/vocab',
                      arguments: lesson.id,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
