// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DebtEntryAdapter extends TypeAdapter<DebtEntry> {
  @override
  final int typeId = 0;

  @override
  DebtEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DebtEntry(
      date: fields[0] as DateTime,
      description: fields[1] as String,
      amount: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, DebtEntry obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.amount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DebtEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PersonDebtAdapter extends TypeAdapter<PersonDebt> {
  @override
  final int typeId = 1;

  @override
  PersonDebt read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PersonDebt(
      name: fields[0] as String,
      debts: (fields[1] as List).cast<DebtEntry>(),
    );
  }

  @override
  void write(BinaryWriter writer, PersonDebt obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.debts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonDebtAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
