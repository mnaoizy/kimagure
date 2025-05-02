import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/vocab_list_model.dart';
import '../screens/vocab_detail_screen.dart';

class VocabListScreen extends StatelessWidget {
  const VocabListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final lessonId = args is String ? args : null;
    if (lessonId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<VocabListModel>().fetchVocabList(lessonId);
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('単語一覧'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              if (lessonId != null) {
                context.read<VocabListModel>().fetchVocabList(lessonId);
              }
            },
          ),
        ],
      ),
      body: Consumer<VocabListModel>(
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
                    onPressed: () {
                      if (lessonId != null) {
                        model.fetchVocabList(lessonId);
                      }
                    },
                    child: const Text('再試行'),
                  ),
                ],
              ),
            );
          }
          if (model.vocabItems.isEmpty) {
            return const Center(child: Text('単語が登録されていません'));
          }
          return ListView.builder(
            itemCount: model.vocabItems.length,
            itemBuilder: (context, index) {
              final item = model.vocabItems[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VocabDetailScreen(item: item),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.character,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.pinyin,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.meaning,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
