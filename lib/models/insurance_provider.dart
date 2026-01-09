import 'package:hive/hive.dart';

part 'insurance_provider.g.dart';

@HiveType(typeId: 3)
class InsuranceProvider extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String providerName;

  @HiveField(2)
  String policyNumber;

  @HiveField(3)
  String type; // health, dental, vision, life, etc.

  @HiveField(4)
  DateTime startDate;

  @HiveField(5)
  DateTime? expiryDate;

  @HiveField(6)
  String coverageDetails;

  @HiveField(7)
  String contactPhone;

  @HiveField(8)
  String contactEmail;

  @HiveField(9)
  String membershipId;

  @HiveField(10)
  bool isActive;

  @HiveField(11)
  String notes;

  InsuranceProvider({
    required this.id,
    required this.providerName,
    required this.policyNumber,
    required this.type,
    required this.startDate,
    this.expiryDate,
    this.coverageDetails = '',
    this.contactPhone = '',
    this.contactEmail = '',
    this.membershipId = '',
    this.isActive = true,
    this.notes = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'providerName': providerName,
      'policyNumber': policyNumber,
      'type': type,
      'startDate': startDate.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
      'coverageDetails': coverageDetails,
      'contactPhone': contactPhone,
      'contactEmail': contactEmail,
      'membershipId': membershipId,
      'isActive': isActive,
      'notes': notes,
    };
  }

  factory InsuranceProvider.fromJson(Map<String, dynamic> json) {
    return InsuranceProvider(
      id: json['id'] as String,
      providerName: json['providerName'] as String,
      policyNumber: json['policyNumber'] as String,
      type: json['type'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'] as String)
          : null,
      coverageDetails: json['coverageDetails'] as String? ?? '',
      contactPhone: json['contactPhone'] as String? ?? '',
      contactEmail: json['contactEmail'] as String? ?? '',
      membershipId: json['membershipId'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? true,
      notes: json['notes'] as String? ?? '',
    );
  }
}
