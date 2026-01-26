// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archived_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArchivedItemAdapter extends TypeAdapter<ArchivedItem> {
  @override
  final int typeId = 0;

  @override
  ArchivedItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ArchivedItem(
      id: fields[0] as String,
      presetName: fields[1] as String,
      originalText: fields[2] as String,
      rewrittenText: fields[3] as String,
      timestamp: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ArchivedItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.presetName)
      ..writeByte(2)
      ..write(obj.originalText)
      ..writeByte(3)
      ..write(obj.rewrittenText)
      ..writeByte(4)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArchivedItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
