// feedback_model.dart
import 'package:hive/hive.dart';
part 'feedback_model.g.dart';

@HiveType(typeId: 1)
class FeedbackModel {
  @HiveField(0)
  late String saran;

  @HiveField(1)
  late String kesan;

  FeedbackModel({
    required this.saran,
    required this.kesan,
  });
}
