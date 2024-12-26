import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dictionaryenglish/class/Item.dart';
import 'package:dictionaryenglish/db/dbMain.dart';
import 'package:dictionaryenglish/constants/colors.dart';
import 'package:dictionaryenglish/adsManager.dart';

class FloatingButton extends StatefulWidget {
  final String wordEnglish; // İngilizce kelime
  final String defintion; // Kelimenin tanımı

  FloatingButton({required this.wordEnglish, required this.defintion, Key? key}) : super(key: key);

  @override
  State<FloatingButton> createState() => _FloatingButtonState();
}

class _FloatingButtonState extends State<FloatingButton> {
  late TextEditingController controllerWord; // Kelime için TextField kontrolcüsü
  late TextEditingController controllerDefinition; // Tanım için TextField kontrolcüsü

  @override
  void initState() {
    super.initState();
    controllerWord = TextEditingController(text: widget.wordEnglish);
    controllerDefinition = TextEditingController(text: widget.defintion);
  }

  @override
  void dispose() {
    controllerWord.dispose();
    controllerDefinition.dispose();
    super.dispose();
  }

  /// Reklam gösterimi için %25 olasılıkla çalışan fonksiyon
  Future<void> _showAdWithProbability(double probability) async {
    final random = Random();
    if (random.nextDouble() < probability) {
      await AdManager.showIntAd();
    }
  }

  /// Kelimeyi veritabanına ekler
  Future<void> _saveWord() async {
    await _showAdWithProbability(0.25); // %25 olasılıkla reklam göster

    final word = controllerWord.text.isNotEmpty ? controllerWord.text : "No data";
    final definition = controllerDefinition.text.isNotEmpty ? controllerDefinition.text : "No data";

    await DB.insertItem(Item(
      questionDefinition: definition,
      answerWord: word,
    ));
    Navigator.pop(context); // Dialog'u kapat
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: accentColor,
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          backgroundColor: secondaryColor,
          title: Text(
            'Save Word',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: textColor,
            ),
          ),
          content: SizedBox(
            height: 200,
            child: Column(
              children: [
                _buildInputField(controllerWord, "Word"),
                const SizedBox(height: 10),
                _buildInputField(controllerDefinition, "Definition", maxLines: 4),
              ],
            ),
          ),
          actions: [
            _buildDialogButton(
              label: "Cancel",
              color: Colors.redAccent,
              onPressed: () async {
                await _showAdWithProbability(0.25);
                Navigator.pop(context);
              },
            ),
            _buildDialogButton(
              label: "Save",
              color: Colors.greenAccent,
              onPressed: _saveWord,
            ),
          ],
        ),
      ),
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  /// TextField tasarımı
  Widget _buildInputField(TextEditingController controller, String label, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.grey.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  /// Düğme tasarımı
  Widget _buildDialogButton({required String label, required Color color, required VoidCallback onPressed}) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
