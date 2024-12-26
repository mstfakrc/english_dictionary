import 'package:clay_containers/clay_containers.dart';
import 'package:dictionaryenglish/class/Item.dart';
import 'package:dictionaryenglish/constants/colors.dart';
import 'package:dictionaryenglish/db/dbMain.dart';
import 'package:flutter/material.dart';

class ListWordPage extends StatefulWidget {
  const ListWordPage({super.key});

  @override
  State<ListWordPage> createState() => _ListWordPageState();
}

class _ListWordPageState extends State<ListWordPage> {
  List<Item> itemList = [];

  @override
  void initState() {
    super.initState();
    loadWords();
  }

  /// Veritabanından kelimeleri yükler
  void loadWords() async {
    List<Item> words = await DB.readItem();
    setState(() {
      itemList = words;
    });
  }

  /// Kelimeyi siler ve listeyi günceller
  void deleteWord(int index) async {
    await DB.deleteItem(itemList[index]);
    setState(() {
      itemList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Ekran genişliği ve yüksekliği
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 5,
        toolbarHeight: screenHeight * 0.1,
        centerTitle: true,
        title: Text(
          "List Words",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.06,
            color: textColor,
          ),
        ),
      ),
      backgroundColor: secondaryColor,
      body: itemList.isEmpty
          ? Center(
              child: ClayContainer(
                color: primaryColor,
                borderRadius: 15,
                spread: 3,
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  child: Text(
                    "No words added yet!",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: screenWidth * 0.05,
                      color: textColor,
                    ),
                  ),
                ),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.02,
                  horizontal: screenWidth * 0.05),
              itemCount: itemList.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.horizontal,
                  background: Container(
                    decoration: BoxDecoration(
                      color: errorColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: screenWidth * 0.07,
                    ),
                  ),
                  secondaryBackground: Container(
                    decoration: BoxDecoration(
                      color: errorColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: screenWidth * 0.07,
                    ),
                  ),
                  onDismissed: (direction) {
                    deleteWord(index);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.01),
                    child: ClayContainer(
                      color: primaryColor,
                      spread: 5,
                      borderRadius: 15,
                      child: ExpansionTile(
                        leading: CircleAvatar(
                          backgroundColor: accentColor,
                          radius: screenWidth * 0.05,
                          child: Text(
                            "${index + 1}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                        ),
                        title: Text(
                          itemList[index].answerWord,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: textColor,
                            fontSize: screenWidth * 0.045,
                          ),
                        ),
                        iconColor: textColor,
                        collapsedIconColor: textColor,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05,
                              vertical: screenHeight * 0.015,
                            ),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: accentColor.withOpacity(0.1),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                            ),
                            child: Text(
                              "Definition: ${itemList[index].questionDefinition}",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white70,
                                fontSize: screenWidth * 0.04,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
