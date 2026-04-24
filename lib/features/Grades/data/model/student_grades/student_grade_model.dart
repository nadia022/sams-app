import 'package:sams_app/core/utils/constants/api_keys.dart';

class StudentGradeModel {
  final String classwork;
  final num? score; // Using num? to handle both int, double, and null values
  final num maxScore; // Using num to be safe with different numeric formats
  final bool isVisible;

  StudentGradeModel({
    required this.classwork,
    this.score,
    required this.maxScore,
    required this.isVisible,
  });

  factory StudentGradeModel.fromJson(Map<String, dynamic> json) {
    return StudentGradeModel(
      classwork: json[ApiKeys.classwork] as String,
      score: json[ApiKeys.score] as num?,
      maxScore: json[ApiKeys.maxScore] as num,
      isVisible: json[ApiKeys.isVisible] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.classwork: classwork,
      ApiKeys.score: score,
      ApiKeys.maxScore: maxScore,
      ApiKeys.isVisible: isVisible,
    };
  }
}
