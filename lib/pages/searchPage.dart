import 'dart:math';

import 'package:clay_containers/clay_containers.dart';
import 'package:dictionaryenglish/adsManager.dart';
import 'package:dictionaryenglish/apiGet/apiFunction.dart';
import 'package:dictionaryenglish/class/Word.dart';
import 'package:dictionaryenglish/constants/colors.dart';
import 'package:dictionaryenglish/widgets/alertSave.dart';
import 'package:dictionaryenglish/widgets/listWord.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<Word>? wordData;
  Word? changeData;
  Widget widgetToShow = Container();
  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: secondaryColor,
      floatingActionButton: widgetToShow,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 5,
        centerTitle: true,
        title: Text(
          "Search Words",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: screenWidth * 0.06,
            color: textColor,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight * 0.1),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: screenHeight * 0.07,
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04),
                      child: TextField(
                        controller: _controller,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          hintText: "Enter a word...",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: screenWidth * 0.04,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.03),
                GestureDetector(
                  onTap: () async {
                    setState(() {});
                    final random = Random();
                    final num = random.nextDouble();

                    if (num < 0.10) {
                      await AdManager.showIntAd();
                    }

                    String wordSearch = _controller.text;
                    wordData = fetchData(
                        "https://api.dictionaryapi.dev/api/v2/entries/en/$wordSearch");

                    changeData = await wordData;

                    if (changeData!.word != "Error") {
                      setState(() {
                        widgetToShow = FloatingButton(
                          wordEnglish: changeData!.word,
                          defintion: changeData!.meanings[0].meanings,
                        );
                      });
                    } else {
                      setState(() {
                        widgetToShow = Container();
                      });
                    }
                  },
                  child: Container(
                    height: screenWidth * 0.12,
                    width: screenWidth * 0.12,
                    decoration: BoxDecoration(
                      color: accentColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.search, color: textColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder<Word>(
        future: wordData,
        builder: (BuildContext context, AsyncSnapshot<Word> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: accentColor,
              ),
            );
          } else if (snapshot.hasData) {
            Word listWords = snapshot.data!;

            if (listWords.word == "Error") {
              return Center(
                child: ClayContainer(
                  width: screenWidth * 0.4,
                  height: screenHeight * 0.07,
                  spread: 3,
                  borderRadius: 10,
                  color: secondaryColor,
                  child: Center(
                    child: Text(
                      "Word Not Found!",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: errorColor,
                        fontSize: screenWidth * 0.045,
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return listWord(listWords, context);
            }
          } else {
            return Center(
              child: ClayContainer(
                width: screenWidth * 0.4,
                height: screenHeight * 0.07,
                spread: 3,
                borderRadius: 10,
                color: secondaryColor,
                child: Center(
                  child: Text(
                    "Search a Word",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: textColor,
                      fontSize: screenWidth * 0.045,
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
