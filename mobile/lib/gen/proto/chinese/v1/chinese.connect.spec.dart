//
//  Generated code. Do not modify.
//  source: proto/chinese/v1/chinese.proto
//

import "package:connectrpc/connect.dart" as connect;
import "chinese.pb.dart" as protochinesev1chinese;

abstract final class ChineseService {
  /// Fully-qualified name of the ChineseService service.
  static const name = 'chinese.v1.ChineseService';

  static const getLessons = connect.Spec(
    '/$name/GetLessons',
    connect.StreamType.unary,
    protochinesev1chinese.GetLessonsRequest.new,
    protochinesev1chinese.GetLessonsResponse.new,
  );

  static const getChineseList = connect.Spec(
    '/$name/GetChineseList',
    connect.StreamType.unary,
    protochinesev1chinese.GetChineseListRequest.new,
    protochinesev1chinese.GetChineseListResponse.new,
  );

  static const uploadRecording = connect.Spec(
    '/$name/UploadRecording',
    connect.StreamType.unary,
    protochinesev1chinese.UploadRecordingRequest.new,
    protochinesev1chinese.UploadRecordingResponse.new,
  );

  static const getFeedbacks = connect.Spec(
    '/$name/GetFeedbacks',
    connect.StreamType.unary,
    protochinesev1chinese.GetFeedbackRequest.new,
    protochinesev1chinese.GetFeedbacksResponse.new,
  );
}
