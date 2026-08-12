import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/reminder.dart';
import 'screens/setup_screen.dart';
import 'screens/home_screen.dart';
import 'services/voice_profile_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ReminderAdapter());

  bool isRegistered = await VoiceProfileService.isOwnerRegistered();

  runApp(MyApp(isRegistered: isRegistered));
}

class MyApp extends StatelessWidget {
  final bool isRegistered;

  const MyApp({super.key, required this.isRegistered});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Myanmar Voice AI Assistant',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: isRegistered ? const HomeScreen() : const SetupScreen(),
    );
  }
}
