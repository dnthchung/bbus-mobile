// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_notification_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalNotificationModelAdapter
    extends TypeAdapter<LocalNotificationModel> {
  @override
  final int typeId = 0;

  @override
  LocalNotificationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalNotificationModel(
      title: fields[0] as String,
      body: fields[1] as String,
      timestamp: fields[2] as DateTime,
      isRead: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, LocalNotificationModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.body)
      ..writeByte(2)
      ..write(obj.timestamp)
      ..writeByte(3)
      ..write(obj.isRead);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalNotificationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
