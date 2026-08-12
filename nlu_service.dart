class NluResult {
  final String action; // 'add', 'delete', 'list_today', 'list_tomorrow', 'list_all', 'read_ocr', 'unknown'
  final String text;
  final DateTime? targetTime;
  final String category;

  NluResult({
    required this.action,
    required this.text,
    this.targetTime,
    this.category = 'general',
  });
}

class NluService {
  static NluResult parseCommand(String spokenText) {
    String text = spokenText.trim();

    // Command check
    if (text.contains('ဒီနေ့ အလုပ်တွေပြော') || text.contains('ဒီနေ့ သတိပေးတွေပြော')) {
      return NluResult(action: 'list_today', text: text);
    }
    if (text.contains('မနက်ဖြန် သတိပေးတွေပြော') || text.contains('မနက်ဖြန် ဘာလုပ်စရာရှိလဲ')) {
      return NluResult(action: 'list_tomorrow', text: text);
    }
    if (text.contains('စာဖတ်စရာရှိလား') || text.contains('ပြန်ပြော')) {
      return NluResult(action: 'list_all', text: text);
    }
    if (text.contains('ဖျက်လိုက်')) {
      return NluResult(action: 'delete', text: text);
    }

    // Reminder addition check
    if (text.contains('သတိပေး')) {
      // Extract task description by removing 'သတိပေး' and time keywords
      String cleanedTask = text.replaceAll('သတိပေး', '').trim();
      
      DateTime now = DateTime.now();
      DateTime targetDate = now;
      String category = 'general';

      // Day interpretation
      if (text.contains('မနက်ဖြန်')) {
        targetDate = now.add(const Duration(days: 1));
        cleanedTask = cleanedTask.replaceAll('မနက်ဖြန်', '').trim();
      } else if (text.contains('သန်ဘက်ခါ')) {
        targetDate = now.add(const Duration(days: 2));
        cleanedTask = cleanedTask.replaceAll('သန်ဘက်ခါ', '').trim();
      } else if (text.contains('ဒီနေ့')) {
        targetDate = now;
        cleanedTask = cleanedTask.replaceAll('ဒီနေ့', '').trim();
      }

      // Time of day interpretation (setting default hours)
      int targetHour = 9; // default morning
      if (text.contains('မနက်')) {
        targetHour = 8;
        category = 'morning';
        cleanedTask = cleanedTask.replaceAll('မနက်', '').trim();
      } else if (text.contains('နေ့လည်')) {
        targetHour = 12;
        category = 'afternoon';
        cleanedTask = cleanedTask.replaceAll('နေ့လည်', '').trim();
      } else if (text.contains('ညနေ')) {
        targetHour = 17;
        category = 'evening';
        cleanedTask = cleanedTask.replaceAll('ညနေ', '').trim();
      } else if (text.contains('ည')) {
        targetHour = 20;
        category = 'night';
        cleanedTask = cleanedTask.replaceAll('ည', '').trim();
      }

      // Clean up particle words like ဖို့, မှာ
      cleanedTask = cleanedTask.replaceAll(RegExp(r'(ဖို့|မှာ|ကို)$'), '').trim();

      DateTime finalTargetTime = DateTime(
        targetDate.year,
        targetDate.month,
        targetDate.day,
        targetHour,
        0,
      );

      return NluResult(
        action: 'add',
        text: cleanedTask.isNotEmpty ? cleanedTask : text,
        targetTime: finalTargetTime,
        category: category,
      );
    }

    return NluResult(action: 'unknown', text: text);
  }
}
