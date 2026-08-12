// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder.dart';

// **************************************************************************
// TypeAdapter implementation and registration
class ReminderAdapter extends TypeAdapter<Reminder> {
  @override
  final int typeId = 0;

  @override
  Reminder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int>[10];
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return Reminder(
      id: fields[0] as String,
      title: fields[1] as String,
      targetTime: fields[2] as DateTime,
      isCompleted: fields[3] as bool,
      category: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Reminder obj) {
    writer
      .writeByte(5);
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.title);
    writer.writeByte(2);
    writer.write(obj.targetTime);
    writer.writeByte(3);
    writer.write(obj.isCompleted);
    writer.writeByte(4);
    writer.write(obj.category);
  }

  @override
  // ignore: unnecessary_cast
  int to_accessor_type() => 0;
}
