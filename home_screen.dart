import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/reminder.dart';
import '../services/reminder_service.dart';
import '../services/nlu_service.dart';
import '../services/tts_service.dart';
import '../services/voice_profile_service.dart';
import '../services/ocr_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Reminder> _reminders = [];
  bool _isListening = false;
  String _lastSpokenText = '';
  String _assistantReply = '';

  @override
  void initState() {
    super.initState();
    _loadReminders();
    TtsService.init();
  }

  Future<void> _loadReminders() async {
    List<Reminder> reminders = await ReminderService.getAllReminders();
    setState(() {
      _reminders = reminders;
    });
  }

  Future<void> _handleVoiceCommand(String spokenText) async {
    setState(() {
      _lastSpokenText = spokenText;
    });

    // Verify voice profile
    List<double> sampleFeatures = [0.12, 0.45, 0.89, 0.33, 0.77]; // simulated sample
    bool isOwner = await VoiceProfileService.verifyOwnerVoice(sampleFeatures);

    if (!isOwner) {
      setState(() {
        _assistantReply = 'ခွင့်ပြုချက်မရှိပါ။ အခြားသူ၏ အသံကို လက်မခံပါ။';
      });
      TtsService.speak(_assistantReply);
      return;
    }

    NluResult result = NluService.parseCommand(spokenText);

    switch (result.action) {
      case 'add':
        Reminder newReminder = Reminder(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: result.text,
          targetTime: result.targetTime ?? DateTime.now().add(const Duration(hours: 1)),
          category: result.category,
        );
        await ReminderService.addReminder(newReminder);
        await _loadReminders();

        String dateStr = 'မနက်ဖြန်';
        if (result.targetTime!.day == DateTime.now().day) {
          dateStr = 'ဒီနေ့';
        }
        _assistantReply = 'ကောင်းပါပြီ။ $dateStr ${result.text} သတိပေးထားပါတယ်။';
        break;

      case 'list_today':
        DateTime today = DateTime.now();
        List<Reminder> todayReminders = await ReminderService.getRemindersForDate(today);
        if (todayReminders.isEmpty) {
          _assistantReply = 'ဒီနေ့အတွက် လုပ်စရာ သတိပေးချက် မရှိပါဘူး။';
        } else {
          String tasks = todayReminders.map((r) => r.title).join('၊ ');
          _assistantReply = 'ဒီနေ့ လုပ်စရာရှိတာတွေကတော့ $tasks ဖြစ်ပါတယ်။';
        }
        break;

      case 'list_tomorrow':
        DateTime tomorrow = DateTime.now().add(const Duration(days: 1));
        List<Reminder> tomReminders = await ReminderService.getRemindersForDate(tomorrow);
        if (tomReminders.isEmpty) {
          _assistantReply = 'မနက်ဖြန်အတွက် သတိပေးချက် မရှိပါဘူး။';
        } else {
          String tasks = tomReminders.map((r) => r.title).join('၊ ');
          _assistantReply = 'မနက်ဖြန် လုပ်စရာရှိတာတွေကတော့ $tasks ဖြစ်ပါတယ်။';
        }
        break;

      case 'list_all':
        if (_reminders.isEmpty) {
          _assistantReply = 'မှတ်သားထားသော သတိပေးချက် မရှိသေးပါ။';
        } else {
          String tasks = _reminders.map((r) => r.title).join('၊ ');
          _assistantReply = 'လက်ရှိ မှတ်သားထားသည်များမှာ $tasks ဖြစ်ပါတယ်။';
        }
        break;

      case 'delete':
        if (_reminders.isNotEmpty) {
          await ReminderService.deleteReminder(_reminders.last.id);
          await _loadReminders();
          _assistantReply = 'နောက်ဆုံး သတိပေးချက်ကို ဖျက်လိုက်ပါပြီ။';
        } else {
          _assistantReply = 'ဖျက်ရန် သတိပေးချက် မရှိပါ။';
        }
        break;

      default:
        _assistantReply = 'အမိန့်ကို နားမလည်ပါ။ ကျေးဇူးပြု၍ ပြန်ပြောပါ။';
        break;
    }

    setState(() {});
    TtsService.speak(_assistantReply);
  }

  Future<void> _pickImageAndOcr() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      String extractedText = await OcrService.recognizeText(image.path);
      setState(() {
        _assistantReply = 'OCR ဖတ်ရရှိသော စာသား: $extractedText';
      });
      TtsService.speak('စာသား ဖတ်ရှုပြီးပါပြီ။ $extractedText');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('မြန်မာ အသံလက်ထောက် (Voice AI)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: _pickImageAndOcr,
            tooltip: 'OCR OCR Reading',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Column(
              children: [
                Text('နောက်ဆုံး ပြောဆိုချက်: "$_lastSpokenText"', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text('လက်ထောက် ဖြေကြားချက်: "$_assistantReply"', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            key: Key('reminder_title_key'),
            child: Text('သတိပေးချက်များ (Reminders)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: _reminders.isEmpty
                ? const Center(child: Text('သတိပေးချက် မရှိသေးပါ။ အသံဖြင့် အမိန့်ပေးနိုင်ပါသည်။'))
                : ListView.builder(
                    itemCount: _reminders.length,
                    itemBuilder: (context, index) {
                      final reminder = _reminders[index];
                      return ListTile(
                        leading: const Icon(Icons.notifications_active, color: Colors.orange),
                        title: Text(reminder.title),
                        subtitle: Text('ချိန်ကိုက်: ${reminder.targetTime.toString().substring(0, 16)}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await ReminderService.deleteReminder(reminder.id);
                            _loadReminders();
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Simulate voice command trigger
          _handleVoiceCommand('မနက်ဖြန် အလုပ်သွားဖို့ သတိပေး');
        },
        icon: const Icon(Icons.mic),
        label: const Text('အသံဖြင့် အမိန့်ပေးမည်'),
      ),
    );
  }
}
