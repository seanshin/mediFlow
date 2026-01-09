// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insurance_provider.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InsuranceProviderAdapter extends TypeAdapter<InsuranceProvider> {
  @override
  final int typeId = 3;

  @override
  InsuranceProvider read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InsuranceProvider(
      id: fields[0] as String,
      providerName: fields[1] as String,
      policyNumber: fields[2] as String,
      type: fields[3] as String,
      startDate: fields[4] as DateTime,
      expiryDate: fields[5] as DateTime?,
      coverageDetails: fields[6] as String,
      contactPhone: fields[7] as String,
      contactEmail: fields[8] as String,
      membershipId: fields[9] as String,
      isActive: fields[10] as bool,
      notes: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, InsuranceProvider obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.providerName)
      ..writeByte(2)
      ..write(obj.policyNumber)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.expiryDate)
      ..writeByte(6)
      ..write(obj.coverageDetails)
      ..writeByte(7)
      ..write(obj.contactPhone)
      ..writeByte(8)
      ..write(obj.contactEmail)
      ..writeByte(9)
      ..write(obj.membershipId)
      ..writeByte(10)
      ..write(obj.isActive)
      ..writeByte(11)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InsuranceProviderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
