class Word {
  String word;
  String phonetics = "";
  List<Meaning> meanings;

  Word({
    required this.word,
    required this.phonetics,
    required this.meanings,
  });
}

class Meaning {
  String partOfSpeech = "No partOfSpeech";
  String meanings = "No Meaning";
  String example = "No example";
  List<dynamic> synonyms = [];
  List<dynamic> antonyms = [];

  Meaning({
    required this.partOfSpeech,
    required this.meanings,
    required this.example,
    required this.synonyms,
    required this.antonyms,
  });
}
