import 'package:hive/hive.dart';

part 'reminder.g.dart';

@HiveType(typeId: 0)
class Reminder extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  DateTime targetTime;

  @HiveField(3)
  bool isCompleted;

  @HiveField(4)
  String category; // e.g., 'morning', 'afternoon', 'evening', 'night'

  Reminder({
    required this.id,
    required this.title,
    required this.targetTime,
    this.isCompleted = false,
    this.category = 'general',
  });
}
