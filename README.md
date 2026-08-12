# Myanmar Voice AI Assistant (Voice-Profile Version)

The **Myanmar Voice AI Assistant** is an offline-first mobile application built with **Flutter**, designed specifically for Myanmar-language voice interaction, owner voice verification, natural-language reminder interpretation without exact clock times, OCR text reading, and persistent local storage.

---

## Architecture & Technical Stack

| Component | Technology / Library | Purpose |
| :--- | :--- | :--- |
| **Mobile Framework** | Flutter (Dart) | Cross-platform mobile application development for Android and iOS. |
| **Local Database** | Hive (`hive_flutter`) | Fast, lightweight, NoSQL offline database for reminders and voice profile features. |
| **Voice Profile Security** | Custom Embedding Verification | Enrolls and verifies the owner's voice features against unauthorized speakers. |
| **Natural Language Understanding** | Custom Myanmar NLU Parser | Parses natural spoken phrases like "မနက်ဖြန် အလုပ်သွားဖို့ သတိပေး" into structured reminders without requiring exact hours. |
| **Voice Interaction** | `flutter_tts` & `speech_to_text` | Offline-friendly Text-to-Speech (Myanmar localization `my-MM`) and voice command listening. |
| **OCR Reading** | Google ML Kit Text Recognition (`google_mlkit_text_recognition`) | Extracts text from camera images (Myanmar, English, Thai) to read aloud or convert to tasks. |
| **Background Scheduling** | `android_alarm_manager_plus` / WorkManager | Ensures reminders trigger precisely when due, even when the app is in the background or offline. |

---

## Core Features Implemented

### 1. Voice Profile & Security
During initial setup, the owner's voice is registered and stored locally in Hive. Whenever a voice command is received, the assistant verifies the speaker's voice features. If an unauthorized voice attempts to add, edit, or delete reminders, access is denied and spoken rejection is issued:
> *"ခွင့်ပြုချက်မရှိပါ။ အခြားသူ၏ အသံကို လက်မခံပါ။"*

### 2. Natural Language Understanding (NLU) & Time Inference
Users speak naturally without providing exact hours. The assistant automatically interprets time markers:
- **Time Keywords**: `မနက်` (Morning -> 8:00 AM), `နေ့လည်` (Afternoon -> 12:00 PM), `ညနေ` (Evening -> 5:00 PM), `ည` (Night -> 8:00 PM).
- **Date Keywords**: `ဒီနေ့` (Today), `မနက်ဖြန်` (Tomorrow), `သန်ဘက်ခါ` (Day after tomorrow).

**Examples**:
- User: *"မနက်ဖြန် အလုပ်သွားဖို့ သတိပေး။"*
- Assistant: *"ကောင်းပါပြီ။ မနက်ဖြန် အလုပ်သွားဖို့ သတိပေးထားပါတယ်။"*

### 3. Voice Memory & Commands
- **Querying Reminders**:
  - *"ဒီနေ့ အလုပ်တွေပြော"* -> Lists today's tasks.
  - *"မနက်ဖြန် သတိပေးတွေပြော"* / *"မနက်ဖြန် ဘာလုပ်စရာရှိလဲ"* -> Lists tomorrow's tasks.
  - *"စာဖတ်စရာရှိလား"* / *"ပြန်ပြော"* -> Lists all stored reminders.
- **Deleting Reminders**:
  - *"ဖျက်လိုက်"* -> Deletes the latest reminder.

### 4. OCR Reading & Voice Conversion
The user captures a photo of text (Myanmar, English, or Thai). Google ML Kit OCR extracts the text instantly offline, and the assistant reads it aloud and can convert detected content into actionable reminders.

### 5. Offline-First Operation
All reminders, voice profiles, and NLU processing run 100% locally on the device without requiring cloud connectivity or internet access.

---

## Project Directory Structure

```text
myanmar_voice_assistant/
├── pubspec.yaml
├── README.md
├── assets/
└── lib/
    ├── main.dart
    ├── models/
    │   ├── reminder.dart
    │   └── reminder.g.dart
    ├── services/
    │   ├── voice_profile_service.dart
    │   ├── reminder_service.dart
    │   ├── nlu_service.dart
    │   ├── tts_service.dart
    │   └── ocr_service.dart
    └── screens/
        ├── setup_screen.dart
        └── home_screen.dart
```

---

## Getting Started & Build Instructions

1. Ensure Flutter SDK is installed on your local development machine.
2. Clone or open the `myanmar_voice_assistant` directory.
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the application on an Android emulator or physical device:
   ```bash
   flutter run
   ```
