import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrService {
  static final TextRecognizer _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  
  // Note: Google ML Kit supports Latin script (English) and Devanagari/others, or specific script recognizers.
  // Myanmar script recognition uses TextRecognitionScript.latin or custom trained models in ML Kit where available, 
  // or universal text recognition.
  static Future<String> recognizeText(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
    
    String extractedText = '';
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        extractedText += '${line.text}\n';
      }
    }
    return extractedText.trim();
  }

  static void dispose() {
    _textRecognizer.close();
  }
}
