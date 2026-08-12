import 'package:flutter/material.dart';
import '../services/voice_profile_service.dart';
import '../services/tts_service.dart';
import 'home_screen.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  bool _isRecording = false;
  bool _registered = false;

  Future<void> _recordVoiceProfile() async {
    setState(() {
      _isRecording = true;
    });

    TtsService.speak('ကျေးဇူးပြု၍ စကားပြောပါ။ မာန်အောင် ရဲ့ အသံပရိုဖိုင် မှတ်သားနေပါပြီ။');

    // Simulate voice recording and feature extraction for owner voice
    await Future.delayed(const Duration(seconds: 3));

    List<double> dummyVoiceFeatures = [0.12, 0.45, 0.89, 0.33, 0.77];
    await VoiceProfileService.registerOwnerVoice(dummyVoiceFeatures);

    setState(() {
      _isRecording = false;
      _registered = true;
    });

    TtsService.speak('အသံပရိုဖိုင် အောင်မြင်စွာ မှတ်သားပြီးပါပြီ။');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('မြန်မာ အသံလက်ထောက် - အသံပရိုဖိုင် စတင်ခြင်း'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.mic, size: 80, color: Colors.blue),
            const SizedBox(height: 24),
            const Text(
              'ပိုင်ရှင်၏ အသံပရိုဖိုင် မှတ်ပုံတင်ခြင်း',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'ဤ အသံလက်ထောက်သည် သင့်အသံကိုသာ တုံ့ပြန်မည်ဖြစ်ပြီး အခြားသူများ၏ အမိန့်များကို လက်ခံမည်မဟုတ်ပါ။ အသံမှတ်ပုံတင်ရန် အောက်ပါခလုတ်ကို နှိပ်ပါ။',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _isRecording ? null : _recordVoiceProfile,
              icon: Icon(_isRecording ? Icons.hourglass_top : Icons.record_voice_over),
              label: Text(_isRecording ? 'အသံ မှတ်သားနေသည်...' : 'အသံပရိုဖိုင် မှတ်ပုံတင်ရန်'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            if (_registered) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('စတင် အသုံးပြုမည်', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
