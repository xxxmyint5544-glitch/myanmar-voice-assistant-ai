import 'package:hive/hive.dart';

class VoiceProfileService {
  static const String _boxName = 'voice_profile_box';
  static const String _keyIsRegistered = 'is_registered';
  static const String _keyVoiceFeatures = 'voice_features';

  static Future<bool> isOwnerRegistered() async {
    var box = await Hive.openBox(_boxName);
    return box.get(_keyIsRegistered, defaultValue: false);
  }

  static Future<void> registerOwnerVoice(List<double> audioFeatures) async {
    var box = await Hive.openBox(_boxName);
    await box.put(_keyIsRegistered, true);
    await box.put(_keyVoiceFeatures, audioFeatures);
  }

  // Simulated speaker verification: in offline mobile apps with ML Kit / custom TFLite speaker embedding, 
  // we compare audio embedding cosine similarity against the enrolled owner feature vector.
  static Future<bool> verifyOwnerVoice(List<double> sampleFeatures) async {
    var box = await Hive.openBox(_boxName);
    bool registered = box.get(_keyIsRegistered, defaultValue: false);
    if (!registered) return false;

    List<dynamic>? savedFeatures = box.get(_keyVoiceFeatures);
    if (savedFeatures == null) return false;

    // Calculate cosine similarity
    double dotProduct = 0.0;
    double normA = 0.0;
    double normB = 0.0;

    for (int i = 0; i < savedFeatures.length && i < sampleFeatures.length; i++) {
      dotProduct += (savedFeatures[i] as double) * sampleFeatures[i];
      normA += (savedFeatures[i] as double) * (savedFeatures[i] as double);
      normB += sampleFeatures[i] * sampleFeatures[i];
    }

    if (normA == 0 || normB == 0) return false;
    double similarity = dotProduct / (normA * normB);

    // Threshold for verification
    return similarity >= 0.75;
  }
}
