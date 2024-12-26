import 'package:clay_containers/widgets/clay_container.dart';
import 'package:dictionaryenglish/constants/colors.dart';
import 'package:flutter/material.dart';

Widget cardType(String partOfSpeech, String meanings, String textSynonyms,
    String textAntonyms, String example) {
  // RichText widget'ı için ortak bir fonksiyon oluşturuldu
  Widget _buildRichText(String label, String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: '$label: ',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: text,
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  return Container(
    margin: EdgeInsets.only(top: 10),
    padding: EdgeInsets.all(15),
    child: ClayContainer(
      spread: 3,
      borderRadius: 10,
      color: backgroundColor,
      child: Column(
        children: [
          // Part of Speech
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              partOfSpeech,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
          // Details section
          Container(
            padding: EdgeInsets.all(15),
            alignment: Alignment.centerLeft,
            width: double.infinity,
            color: primaryColor,
            child: Column(
              children: [
                _buildRichText('Definition', meanings),
                _buildRichText('Synonyms', textSynonyms),
                _buildRichText('Antonyms', textAntonyms),
                _buildRichText('Example', example),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
