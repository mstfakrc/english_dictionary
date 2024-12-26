import 'package:dictionaryenglish/class/Word.dart';
import 'package:dictionaryenglish/widgets/cardTypes.dart';
import 'package:flutter/material.dart';

List<Widget> obtenerListaDeWidgets(Word wordData) {
  List<Widget> widgets = [];

  for (int index = 0; index < wordData.meanings.length; index++) {
    widgets.add(cardType(
        wordData.meanings[index].partOfSpeech,
        wordData.meanings[index].meanings,
        wordData.meanings[index].synonyms.toString(),
        wordData.meanings[index].antonyms.toString(),
        wordData.meanings[index].example));
  }

  return widgets;
}
