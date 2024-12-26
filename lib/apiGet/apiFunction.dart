import 'dart:convert'; // JSON çözümlemek için
import 'package:dictionaryenglish/class/Word.dart'; // Word sınıfı için
import 'package:http/http.dart' as http; // HTTP isteklerini yapmak için
import 'package:flutter/material.dart'; // Flutter widget'ları için

/// Verilen URL'den kelime verilerini alır ve bir [Word] nesnesi döndürür.
Future<Word> fetchData(String url) async {
  Word defaultWord = Word(word: "Error", phonetics: "Error", meanings: []); // Hata durumunda döndürülecek varsayılan Word nesnesi

  try {
    final response = await http.get(Uri.parse(url)); // URL'ye GET isteği yapar

    if (response.statusCode == 200) {
      // İstek başarılıysa
      final List<dynamic> data = json.decode(response.body); // Gelen JSON verisini çözümle
      final Map<String, dynamic> wordData = data[0]; // İlk kelime verisini al
      return parseWord(wordData); // Kelimeyi işle ve döndür
    } else {
      // İstek başarısız olduysa
      print('Failed to load data. Status code: ${response.statusCode}');
    }
  } catch (error) {
    // Hata durumunda
    print('Error: $error');
  }

  return defaultWord; // Hata durumunda varsayılan kelimeyi döndür
}

/// [meaningsData] listesindeki anlamları işleyerek [Meaning] listesi oluşturur.
List<Meaning> parseMeanings(dynamic meaningsData) {
  return meaningsData.map<Meaning>((meaning) {
    return Meaning(
      partOfSpeech: meaning["partOfSpeech"] ?? "No data", // Kelimenin türü (örn. noun, verb)
      meanings: meaning["definitions"][0]["definition"] ?? "No data", // Anlam
      example: meaning["definitions"][0]["example"] ?? "No data", // Örnek cümle
      synonyms: meaning["synonyms"] ?? "No data", // Eş anlamlılar
      antonyms: meaning["antonyms"] ?? "No data", // Zıt anlamlılar
    );
  }).toList();
}

/// [phonetics] verisinden ses dosyasının URL'sini alır.
String getAudioUrl(dynamic phonetics) {
  for (var phonetic in phonetics) {
    if (phonetic["audio"] != null && phonetic["audio"]!.isNotEmpty) {
      return phonetic["audio"];
    }
  }
  return "No audio available"; // Ses dosyası yoksa
}

/// [wordData] içindeki "meanings" alanını işleyerek bir [Meaning] listesi oluşturur.
List<Meaning> extractMeanings(dynamic wordData) {
  return wordData.containsKey("meanings") ? parseMeanings(wordData["meanings"]) : [];
}

/// [wordData] verisini işleyerek bir [Word] nesnesi oluşturur.
Word parseWord(dynamic wordData) {
  String audio = getAudioUrl(wordData["phonetics"]); // Ses dosyası URL'si
  List<Meaning> meanings = extractMeanings(wordData); // Anlamlar

  return Word(
    word: wordData["word"], // Kelimenin kendisi
    phonetics: audio, // Ses dosyası URL'si
    meanings: meanings, // Anlam listesi
  );
}
