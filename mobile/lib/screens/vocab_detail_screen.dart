import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import '../models/vocab_detail_model.dart';
import '../gen/proto/chinese/v1/chinese.pb.dart';
import '../widgets/pitch_chart.dart';

class VocabDetailScreen extends StatefulWidget {
  final ChineseItem item;

  const VocabDetailScreen({super.key, required this.item});

  @override
  State<VocabDetailScreen> createState() => _VocabDetailScreenState();
}

class _VocabDetailScreenState extends State<VocabDetailScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final model = context.read<VocabDetailModel>();
    Future.microtask(() async {
      await model.initRecorder();
      await model.loadFeedbacks(widget.item.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.item.character)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Consumer<VocabDetailModel>(
            builder: (context, model, _) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: constraints.maxWidth,
                    minHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.character,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.item.pinyin,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.item.meaning,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 32),
                      if (widget.item.pitchData.isNotEmpty)
                        SizedBox(
                          height: 200,
                          width: MediaQuery.of(context).size.width - 32,
                          child: PitchChart(
                            modelPitch: widget.item.pitchData,
                            userPitch: model.pitches,
                            modelPlaybackPosition:
                                model.isPlaying ? model.playbackProgress : null,
                            userPlaybackPosition:
                                model.isPlayingRecording
                                    ? model.playbackProgress
                                    : null,
                          ),
                        ),
                      const SizedBox(height: 16),
                      Center(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        model.isRecording
                                            ? Icons.stop
                                            : Icons.mic,
                                        size: 48,
                                        color:
                                            model.isRecording
                                                ? Colors.red
                                                : Colors.blue,
                                      ),
                                      onPressed: () async {
                                        await model.toggleRecording(
                                          widget.item.id,
                                        );
                                        setState(() {});
                                      },
                                    ),
                                    if (model.recordedAudioPath != null)
                                      IconButton(
                                        icon: Icon(
                                          model.isPlayingRecording
                                              ? Icons.stop
                                              : Icons.play_arrow,
                                          size: 32,
                                          color: Colors.purple,
                                        ),
                                        onPressed: () async {
                                          if (model.isPlayingRecording) {
                                            await model.stopRecordingPlayback();
                                          } else {
                                            await model.playRecording();
                                          }
                                          setState(() {});
                                        },
                                      ),
                                  ],
                                ),
                                const SizedBox(width: 32),
                                if (widget.item.audioUrl.isNotEmpty)
                                  Column(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          model.isPlaying
                                              ? Icons.stop
                                              : Icons.play_arrow,
                                          size: 48,
                                          color: Colors.green,
                                        ),
                                        onPressed: () async {
                                          if (model.isPlaying) {
                                            await model.stopAudio();
                                          } else {
                                            await model.playAudio(
                                              widget.item.audioUrl,
                                            );
                                          }
                                          setState(() {});
                                        },
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              model.isRecording
                                  ? '録音中...'
                                  : model.isPlaying
                                  ? '再生中...'
                                  : model.isPlayingRecording
                                  ? '録音再生中...'
                                  : widget.item.audioUrl.isNotEmpty
                                  ? '再生可能'
                                  : '録音可能',
                            ),
                            if (model.recordedAudioPath != null)
                              Text(
                                '録音済み',
                                style: TextStyle(color: Colors.purple),
                              ),
                            if (model.isUploading)
                              const Padding(
                                padding: EdgeInsets.all(24.0),
                                child: CircularProgressIndicator(),
                              ),
                            if (model.error != null)
                              Text(
                                model.error!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            if (model.feedback != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Text(
                                  model.feedback!,
                                  style: const TextStyle(
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 16),
                            if (model.feedbacks.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '過去のフィードバック:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ...model.feedbacks.map(
                                    (feedback) => Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            feedback.text,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            feedback.createdAt,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
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
