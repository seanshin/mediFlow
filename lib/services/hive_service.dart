import 'package:hive_flutter/hive_flutter.dart';
import '../models/appointment.dart';
import '../models/prescription.dart';
import '../models/medical_record.dart';
import '../models/insurance_provider.dart';

class HiveService {
  static const String appointmentsBox = 'appointments';
  static const String prescriptionsBox = 'prescriptions';
  static const String medicalRecordsBox = 'medical_records';
  static const String insuranceProvidersBox = 'insurance_providers';

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(AppointmentAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(PrescriptionAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(MedicalRecordAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(InsuranceProviderAdapter());
    }

    // Open boxes
    await Hive.openBox<Appointment>(appointmentsBox);
    await Hive.openBox<Prescription>(prescriptionsBox);
    await Hive.openBox<MedicalRecord>(medicalRecordsBox);
    await Hive.openBox<InsuranceProvider>(insuranceProvidersBox);
  }

  // Appointments
  static Box<Appointment> getAppointmentsBox() {
    return Hive.box<Appointment>(appointmentsBox);
  }

  static Future<void> addAppointment(Appointment appointment) async {
    final box = getAppointmentsBox();
    await box.put(appointment.id, appointment);
  }

  static Future<void> updateAppointment(Appointment appointment) async {
    await addAppointment(appointment);
  }

  static Future<void> deleteAppointment(String id) async {
    final box = getAppointmentsBox();
    await box.delete(id);
  }

  static List<Appointment> getAllAppointments() {
    final box = getAppointmentsBox();
    return box.values.toList();
  }

  // Prescriptions
  static Box<Prescription> getPrescriptionsBox() {
    return Hive.box<Prescription>(prescriptionsBox);
  }

  static Future<void> addPrescription(Prescription prescription) async {
    final box = getPrescriptionsBox();
    await box.put(prescription.id, prescription);
  }

  static Future<void> updatePrescription(Prescription prescription) async {
    await addPrescription(prescription);
  }

  static Future<void> deletePrescription(String id) async {
    final box = getPrescriptionsBox();
    await box.delete(id);
  }

  static List<Prescription> getAllPrescriptions() {
    final box = getPrescriptionsBox();
    return box.values.toList();
  }

  // Medical Records
  static Box<MedicalRecord> getMedicalRecordsBox() {
    return Hive.box<MedicalRecord>(medicalRecordsBox);
  }

  static Future<void> addMedicalRecord(MedicalRecord record) async {
    final box = getMedicalRecordsBox();
    await box.put(record.id, record);
  }

  static Future<void> updateMedicalRecord(MedicalRecord record) async {
    await addMedicalRecord(record);
  }

  static Future<void> deleteMedicalRecord(String id) async {
    final box = getMedicalRecordsBox();
    await box.delete(id);
  }

  static List<MedicalRecord> getAllMedicalRecords() {
    final box = getMedicalRecordsBox();
    return box.values.toList();
  }

  // Insurance Providers
  static Box<InsuranceProvider> getInsuranceProvidersBox() {
    return Hive.box<InsuranceProvider>(insuranceProvidersBox);
  }

  static Future<void> addInsuranceProvider(InsuranceProvider provider) async {
    final box = getInsuranceProvidersBox();
    await box.put(provider.id, provider);
  }

  static Future<void> updateInsuranceProvider(
      InsuranceProvider provider) async {
    await addInsuranceProvider(provider);
  }

  static Future<void> deleteInsuranceProvider(String id) async {
    final box = getInsuranceProvidersBox();
    await box.delete(id);
  }

  static List<InsuranceProvider> getAllInsuranceProviders() {
    final box = getInsuranceProvidersBox();
    return box.values.toList();
  }
}
