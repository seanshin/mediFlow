import 'package:hive/hive.dart';

part 'medical_record.g.dart';

@HiveType(typeId: 2)
class MedicalRecord extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String type; // diagnosis, test_result, surgery, vaccination, etc.

  @HiveField(3)
  String hospitalName;

  @HiveField(4)
  String doctorName;

  @HiveField(5)
  DateTime recordDate;

  @HiveField(6)
  String description;

  @HiveField(7)
  String diagnosis;

  @HiveField(8)
  String treatment;

  @HiveField(9)
  List<String> attachments; // file paths or URLs

  @HiveField(10)
  Map<String, String> testResults; // test name -> result

  MedicalRecord({
    required this.id,
    required this.title,
    required this.type,
    required this.hospitalName,
    required this.doctorName,
    required this.recordDate,
    this.description = '',
    this.diagnosis = '',
    this.treatment = '',
    List<String>? attachments,
    Map<String, String>? testResults,
  })  : attachments = attachments ?? [],
        testResults = testResults ?? {};

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'hospitalName': hospitalName,
      'doctorName': doctorName,
      'recordDate': recordDate.toIso8601String(),
      'description': description,
      'diagnosis': diagnosis,
      'treatment': treatment,
      'attachments': attachments,
      'testResults': testResults,
    };
  }

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    return MedicalRecord(
      id: json['id'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      hospitalName: json['hospitalName'] as String,
      doctorName: json['doctorName'] as String,
      recordDate: DateTime.parse(json['recordDate'] as String),
      description: json['description'] as String? ?? '',
      diagnosis: json['diagnosis'] as String? ?? '',
      treatment: json['treatment'] as String? ?? '',
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      testResults: (json['testResults'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(key, value as String)) ??
          {},
    );
  }
}
