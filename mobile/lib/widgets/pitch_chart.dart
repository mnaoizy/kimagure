import 'dart:math';
import 'package:flutter/material.dart';

class PitchChart extends StatelessWidget {
  final List<double> modelPitch;
  final List<double>? userPitch;
  final double? modelPlaybackPosition;
  final double? userPlaybackPosition;
  final Color modelColor;
  final Color userColor;

  const PitchChart({
    super.key,
    required this.modelPitch,
    this.userPitch,
    this.modelPlaybackPosition,
    this.userPlaybackPosition,
    this.modelColor = Colors.blue,
    this.userColor = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      child: CustomPaint(
        painter: _PitchChartPainter(
          modelPitch: modelPitch,
          userPitch: userPitch,
          modelPlaybackPosition: modelPlaybackPosition,
          userPlaybackPosition: userPlaybackPosition,
          modelColor: modelColor,
          userColor: userColor,
        ),
      ),
    );
  }
}

class _PitchChartPainter extends CustomPainter {
  final List<double> modelPitch;
  final List<double>? userPitch;
  final double? modelPlaybackPosition;
  final double? userPlaybackPosition;
  final Color modelColor;
  final Color userColor;

  _PitchChartPainter({
    required this.modelPitch,
    this.userPitch,
    this.modelPlaybackPosition,
    this.userPlaybackPosition,
    required this.modelColor,
    required this.userColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Draw model pitch
    _drawPitchLine(
      canvas,
      pitch: modelPitch,
      color: modelColor,
      width: width,
      height: height,
    );

    // Draw user pitch if available
    if (userPitch != null && userPitch!.isNotEmpty) {
      _drawPitchLine(
        canvas,
        pitch: userPitch!,
        color: userColor.withOpacity(0.8),
        width: width,
        height: height,
      );
    }

    // Draw playback position indicators
    if (modelPlaybackPosition != null) {
      _drawPlaybackMarker(
        canvas,
        position: modelPlaybackPosition!,
        color: modelColor,
        width: width,
        height: height,
      );
    }

    if (userPlaybackPosition != null) {
      _drawPlaybackMarker(
        canvas,
        position: userPlaybackPosition!,
        color: userColor,
        width: width,
        height: height,
      );
    }
  }

  List<double> _trimPitch(List<double> pitch) {
    if (pitch.isEmpty) return pitch;

    int start = 0;
    while (start < pitch.length && pitch[start] == 0) {
      start++;
    }

    int end = pitch.length - 1;
    while (end >= 0 && pitch[end] == 0) {
      end--;
    }

    if (start > end) return [];
    return pitch.sublist(start, end + 1);
  }

  void _drawPitchLine(
    Canvas canvas, {
    required List<double> pitch,
    required Color color,
    required double width,
    required double height,
  }) {
    final trimmedPitch = _trimPitch(pitch);
    if (trimmedPitch.isEmpty) return;

    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 3.5
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.stroke;

    final trimmedLength = _trimPitch(pitch).length;
    final xStep = width / (trimmedLength > 0 ? trimmedLength : pitch.length);
    final centerY = height * 0.5;
    // 平均値と標準偏差を計算
    final sum = trimmedPitch.fold(0.0, (a, b) => a + b);
    final mean = sum / trimmedPitch.length;
    final variance =
        trimmedPitch.fold(0.0, (a, b) => a + (b - mean) * (b - mean)) /
        trimmedPitch.length;
    final stdDev = sqrt(variance);

    // 固定スケールで表示 (100-400Hzを想定)
    final displayMin = 100.0;
    final displayMax = 400.0;

    Path? path;
    final effectivePitch = _trimPitch(pitch);
    final startIndex = pitch.length - effectivePitch.length;

    for (int i = 0; i < effectivePitch.length; i++) {
      final value = effectivePitch[i];
      final x = i * xStep;
      // 平均±2標準偏差範囲で正規化し、中央を基準に表示
      final normalized = (value - displayMin) / (displayMax - displayMin);
      final y = centerY - (normalized - 0.5) * height * 0.8;

      if (value > 0) {
        if (path == null) {
          path = Path();
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      } else if (path != null) {
        canvas.drawPath(path, paint);
        path = null;
      }
    }
    if (path != null) {
      canvas.drawPath(path, paint);
    }
  }

  void _drawPlaybackMarker(
    Canvas canvas, {
    required double position,
    required Color color,
    required double width,
    required double height,
  }) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round;

    // Calculate position based on audio duration
    final x = width * position.clamp(0.0, 1.0);

    // Draw vertical line
    canvas.drawLine(Offset(x, 0), Offset(x, height), paint);

    // Draw circle at current position
    final circlePaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(x, height * 0.5), 5.0, circlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
