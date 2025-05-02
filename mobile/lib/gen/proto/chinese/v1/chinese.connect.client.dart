//
//  Generated code. Do not modify.
//  source: proto/chinese/v1/chinese.proto
//

import "package:connectrpc/connect.dart" as connect;
import "chinese.pb.dart" as protochinesev1chinese;
import "chinese.connect.spec.dart" as specs;

extension type ChineseServiceClient (connect.Transport _transport) {
  Future<protochinesev1chinese.GetLessonsResponse> getLessons(
    protochinesev1chinese.GetLessonsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ChineseService.getLessons,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<protochinesev1chinese.GetChineseListResponse> getChineseList(
    protochinesev1chinese.GetChineseListRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ChineseService.getChineseList,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<protochinesev1chinese.UploadRecordingResponse> uploadRecording(
    protochinesev1chinese.UploadRecordingRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ChineseService.uploadRecording,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<protochinesev1chinese.GetFeedbacksResponse> getFeedbacks(
    protochinesev1chinese.GetFeedbackRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ChineseService.getFeedbacks,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
