// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_trigger.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageTriggerAdapter extends TypeAdapter<MessageTrigger> {
  @override
  final int typeId = 13;

  @override
  MessageTrigger read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageTrigger(
      type: fields[0] as int,
      pattern: fields[1] as String,
      enableRegex: fields[2] as bool,
      caseSensitive: fields[3] as bool,
      showInMentions: fields[4] as bool,
      sendNotification: fields[5] as bool,
      playSound: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MessageTrigger obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.pattern)
      ..writeByte(2)
      ..write(obj.enableRegex)
      ..writeByte(3)
      ..write(obj.caseSensitive)
      ..writeByte(4)
      ..write(obj.showInMentions)
      ..writeByte(5)
      ..write(obj.sendNotification)
      ..writeByte(6)
      ..write(obj.playSound);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageTriggerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}