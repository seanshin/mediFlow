// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedicalRecordAdapter extends TypeAdapter<MedicalRecord> {
  @override
  final int typeId = 2;

  @override
  MedicalRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedicalRecord(
      id: fields[0] as String,
      title: fields[1] as String,
      type: fields[2] as String,
      hospitalName: fields[3] as String,
      doctorName: fields[4] as String,
      recordDate: fields[5] as DateTime,
      description: fields[6] as String,
      diagnosis: fields[7] as String,
      treatment: fields[8] as String,
      attachments: (fields[9] as List?)?.cast<String>(),
      testResults: (fields[10] as Map?)?.cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, MedicalRecord obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.hospitalName)
      ..writeByte(4)
      ..write(obj.doctorName)
      ..writeByte(5)
      ..write(obj.recordDate)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.diagnosis)
      ..writeByte(8)
      ..write(obj.treatment)
      ..writeByte(9)
      ..write(obj.attachments)
      ..writeByte(10)
      ..write(obj.testResults);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicalRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
