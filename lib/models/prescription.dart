import 'package:hive/hive.dart';

part 'prescription.g.dart';

@HiveType(typeId: 1)
class Prescription extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String medicineName;

  @HiveField(2)
  String dosage;

  @HiveField(3)
  String frequency;

  @HiveField(4)
  int duration; // days

  @HiveField(5)
  String hospitalName;

  @HiveField(6)
  String doctorName;

  @HiveField(7)
  DateTime prescribedDate;

  @HiveField(8)
  String instructions;

  @HiveField(9)
  String category; // antibiotic, painkiller, vitamin, etc.

  @HiveField(10)
  bool isActive;

  Prescription({
    required this.id,
    required this.medicineName,
    required this.dosage,
    required this.frequency,
    required this.duration,
    required this.hospitalName,
    required this.doctorName,
    required this.prescribedDate,
    this.instructions = '',
    this.category = 'general',
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medicineName': medicineName,
      'dosage': dosage,
      'frequency': frequency,
      'duration': duration,
      'hospitalName': hospitalName,
      'doctorName': doctorName,
      'prescribedDate': prescribedDate.toIso8601String(),
      'instructions': instructions,
      'category': category,
      'isActive': isActive,
    };
  }

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      id: json['id'] as String,
      medicineName: json['medicineName'] as String,
      dosage: json['dosage'] as String,
      frequency: json['frequency'] as String,
      duration: json['duration'] as int,
      hospitalName: json['hospitalName'] as String,
      doctorName: json['doctorName'] as String,
      prescribedDate: DateTime.parse(json['prescribedDate'] as String),
      instructions: json['instructions'] as String? ?? '',
      category: json['category'] as String? ?? 'general',
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}
