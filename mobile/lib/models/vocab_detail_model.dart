import 'dart:ffi';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:just_audio/just_audio.dart';
import '../gen/proto/chinese/v1/chinese.pb.dart' as pb;
import '../gen/proto/chinese/v1/chinese.connect.client.dart';
import '../api/transport.dart';

class VocabDetailModel extends ChangeNotifier {
  final ChineseServiceClient _client = ChineseServiceClient(transport);
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final AudioPlayer _player = AudioPlayer();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _disposed = false;
  Duration? _currentPosition;
  Duration? _duration;
  double playbackProgress = 0.0;
  bool isPlaying = false;
  bool isRecording = false;
  bool isUploading = false;
  bool isRecorderReady = false;
  bool isPlayingRecording = false;
  String? recordedAudioPath;
  String? error;
  String? feedback;
  List<double> pitches = [];
  List<pb.Feedback> feedbacks = [];

  Future<void> loadFeedbacks(String itemId) async {
    try {
      final result = await _client.getFeedbacks(
        pb.GetFeedbackRequest(itemId: itemId),
      );
      feedbacks = result.feedbacks;
    } catch (e) {
      feedbacks = [];
      error = null; // エラーを表示しない
      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> initRecorder() async {
    await _recorder.openRecorder();
    isRecorderReady = true;
    notifyListeners();
  }

  Future<void> toggleRecording(String itemId) async {
    if (!isRecorderReady) return;
    if (isRecording) {
      final path = await _recorder.stopRecorder();
      recordedAudioPath = path;
      isRecording = false;
      notifyListeners();
      await uploadRecording(itemId);
    } else {
      final directory = await getTemporaryDirectory();
      recordedAudioPath = null;
      feedback = null;
      isPlayingRecording = false;
      notifyListeners();
      await _recorder.startRecorder(toFile: '${directory.path}/recording.aac');
      isRecording = true;
      notifyListeners();
      await loadFeedbacks(itemId);
      notifyListeners();
    }
  }

  Future<void> playRecording() async {
    if (recordedAudioPath == null) return;
    try {
      // 状態を初期化
      isPlayingRecording = true;
      updatePlaybackProgress(0.0);
      notifyListeners();

      // プレイヤーをリセット
      await _player.stop();
      await _player.setFilePath(recordedAudioPath!);
      await _player.load();

      // 状態監視を開始
      final completer = Completer<void>();
      final positionSub = _player.positionStream.listen((position) {
        if (!_disposed) {
          _currentPosition = position;
          final duration = _player.duration;
          if (duration != null) {
            _duration = duration;
            updatePlaybackProgress(
              position.inMilliseconds / duration.inMilliseconds,
            );
          }
        }
      });

      final stateSub = _player.playerStateStream.listen((state) async {
        if (!_disposed) {
          isPlayingRecording = state.playing;
          notifyListeners();

          if (state.processingState == ProcessingState.completed) {
            await Future.microtask(() {
              if (!_disposed) {
                isPlayingRecording = false;
                notifyListeners();
              }
            });
            if (!_disposed) {
              completer.complete();
            }
          }
        }
      });

      // 再生開始
      await _player.play();

      // 再生完了を待機
      await completer.future;

      // リソース解放
      positionSub.cancel();
      stateSub.cancel();
    } catch (e) {
      error = '録音再生エラー: $e';
      isPlayingRecording = false;
      notifyListeners();
    }
  }

  Future<void> stopRecordingPlayback() async {
    if (!isPlayingRecording) return;
    await _player.stop();
    isPlayingRecording = false;
    notifyListeners();
  }

  Future<void> stopAudio() async {
    await _audioPlayer.pause();
    setPlaying(false);
    notifyListeners();
  }

  Future<void> uploadRecording(String itemId) async {
    isUploading = true;
    error = null;
    try {
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/recording.aac');
      final bytes = await file.readAsBytes();
      final result = await _client.uploadRecording(
        pb.UploadRecordingRequest(itemId: itemId, audioData: bytes),
      );
      feedback = result.feedback;
      print(result.pitches);
      pitches = result.pitches;
    } catch (e) {
      error = e.toString();
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }

  void updatePlaybackProgress(double progress) {
    if (!_disposed) {
      playbackProgress = progress;
      notifyListeners();
    }
  }

  Duration? get currentPosition => _currentPosition;
  Duration? get duration => _duration;

  void setPlaying(bool playing) {
    isPlaying = playing;
    notifyListeners();
  }

  Future<void> playAudio(String url) async {
    try {
      // 状態を初期化
      setPlaying(false);
      updatePlaybackProgress(0.0);
      notifyListeners();

      // プレイヤーをリセット
      await _audioPlayer.stop();
      await _audioPlayer.setUrl(url);
      await _audioPlayer.load();

      // 状態監視を開始
      final completer = Completer<void>();
      final positionSub = _audioPlayer.positionStream.listen((position) {
        if (!_disposed) {
          _currentPosition = position;
          final duration = _audioPlayer.duration;
          if (duration != null) {
            _duration = duration;
            updatePlaybackProgress(
              position.inMilliseconds / duration.inMilliseconds,
            );
          }
        }
      });

      final stateSub = _audioPlayer.playerStateStream.listen((state) async {
        if (!_disposed) {
          setPlaying(state.playing);
          notifyListeners();

          if (state.processingState == ProcessingState.completed) {
            await Future.microtask(() {
              if (!_disposed) {
                setPlaying(false);
                notifyListeners();
              }
            });
            if (!_disposed) {
              completer.complete();
            }
          }
        }
      });

      // 再生開始
      await _audioPlayer.play();

      // 再生完了を待機
      await completer.future;

      // リソース解放
      positionSub.cancel();
      stateSub.cancel();
    } catch (e) {
      error = '再生エラー: $e';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _recorder.closeRecorder();
    _player.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }
}
