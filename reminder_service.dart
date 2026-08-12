import 'package:hive/hive.dart';
import '../models/reminder.dart';

class ReminderService {
  static const String _boxName = 'reminders_box';

  static Future<Box<Reminder>> _openBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<Reminder>(_boxName);
    }
    return Hive.box<Reminder>(_boxName);
  }

  static Future<void> addReminder(Reminder reminder) async {
    var box = await _openBox();
    await box.put(reminder.id, reminder);
  }

  static Future<List<Reminder>> getAllReminders() async {
    var box = await _openBox();
    return box.values.toList();
  }

  static Future<List<Reminder>> getRemindersForDate(DateTime date) async {
    var box = await _openBox();
    return box.values.where((r) => 
      r.targetTime.year == date.year &&
      r.targetTime.month == date.month &&
      r.targetTime.day == date.day
    ).toList();
  }

  static Future<void> deleteReminder(String id) async {
    var box = await _openBox();
    await box.delete(id);
  }

  static Future<void> clearAll() async {
    var box = await _openBox();
    await box.clear();
  }
}
