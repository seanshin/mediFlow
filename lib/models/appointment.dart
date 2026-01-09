import 'package:hive/hive.dart';

part 'appointment.g.dart';

@HiveType(typeId: 0)
class Appointment extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String hospitalName;

  @HiveField(2)
  String department;

  @HiveField(3)
  String doctorName;

  @HiveField(4)
  DateTime appointmentDate;

  @HiveField(5)
  String appointmentTime;

  @HiveField(6)
  String purpose;

  @HiveField(7)
  String status; // scheduled, completed, cancelled

  @HiveField(8)
  String notes;

  @HiveField(9)
  DateTime createdAt;

  Appointment({
    required this.id,
    required this.hospitalName,
    required this.department,
    required this.doctorName,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.purpose,
    this.status = 'scheduled',
    this.notes = '',
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hospitalName': hospitalName,
      'department': department,
      'doctorName': doctorName,
      'appointmentDate': appointmentDate.toIso8601String(),
      'appointmentTime': appointmentTime,
      'purpose': purpose,
      'status': status,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as String,
      hospitalName: json['hospitalName'] as String,
      department: json['department'] as String,
      doctorName: json['doctorName'] as String,
      appointmentDate: DateTime.parse(json['appointmentDate'] as String),
      appointmentTime: json['appointmentTime'] as String,
      purpose: json['purpose'] as String,
      status: json['status'] as String? ?? 'scheduled',
      notes: json['notes'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
