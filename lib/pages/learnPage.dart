import 'package:clay_containers/clay_containers.dart'; // UI tasarımı için
import 'package:dictionaryenglish/class/Item.dart'; // Item sınıfı
import 'package:dictionaryenglish/constants/colors.dart'; // Renk sabitleri
import 'package:dictionaryenglish/db/dbMain.dart'; // Veritabanı işlemleri
import 'package:flutter/material.dart'; // Flutter widget'ları
import 'package:unity_ads_plugin/unity_ads_plugin.dart'; // Reklam gösterimi için

class LearnPage extends StatefulWidget {
  const LearnPage({super.key});

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  List<Item> tasks = [];
  TextEditingController controller = TextEditingController();

  List<Item> _questions = [];
  int _currentIndex = 0;
  String _userAnswer = "";
  String _defaultPhrase = "Loading";

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() async {
    List<Item> allTasks = await DB.readItem();
    allTasks.shuffle();

    setState(() {
      tasks = allTasks;
      _questions = allTasks.take(10).toList();
      if (_questions.isNotEmpty) {
        _defaultPhrase = _questions[_currentIndex].questionDefinition;
      }
    });
  }

  void _submitAnswer() {
    if (_userAnswer.toLowerCase() == _questions[_currentIndex].answerWord.toLowerCase()) {
      _currentIndex = (_currentIndex + 1) % _questions.length;
      _defaultPhrase = _questions[_currentIndex].questionDefinition;
    } else {
      _showErrorDialog();
    }

    controller.clear();
    setState(() {});
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        backgroundColor: primaryColor,
        title: Text("Incorrect Answer", style: TextStyle(color: textColor)),
        content: Text(
          "The correct answer is '${_questions[_currentIndex].answerWord}'",
          style: TextStyle(color: textColor),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _currentIndex = (_currentIndex + 1) % _questions.length;
              _defaultPhrase = _questions[_currentIndex].questionDefinition;
              setState(() {});
            },
            child: ClayContainer(
              spread: 4,
              borderRadius: 10,
              color: primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "OK",
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ekran genişliği ve yüksekliği
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: secondaryColor, // Arka plan rengini secondaryColor olarak ayarladık.
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 5,
        toolbarHeight: screenHeight * 0.1,
        centerTitle: true,
        title: Text(
          "Learn",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.07,
            color: textColor,
          ),
        ),
      ),
      body: _defaultPhrase == 'Loading'
          ? Center(
              child: ClayContainer(
                width: screenWidth * 0.5,
                height: screenHeight * 0.1,
                spread: 5,
                borderRadius: 10,
                color: primaryColor,
                child: Center(
                  child: Text(
                    "Add Words",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.05,
                      color: textColor,
                    ),
                  ),
                ),
              ),
            )
          : Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05, vertical: screenHeight * 0.03),
              child: Column(
                children: [
                  UnityBannerAd(placementId: "Banner_Android"),
                  SizedBox(height: screenHeight * 0.03),
                  ClayContainer(
                    spread: 5,
                    borderRadius: 15,
                    color: primaryColor,
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * 0.05),
                      child: Text(
                        _defaultPhrase,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: textColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  ClayContainer(
                    borderRadius: 15,
                    color: backgroundColor,
                    emboss: true,
                    spread: 5,
                    child: TextField(
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        color: Colors.black,
                      ),
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: "Type your answer...",
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 0.04,
                        ),
                        contentPadding: EdgeInsets.all(screenWidth * 0.04),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) => _userAnswer = value,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  ElevatedButton(
                    onPressed: _submitAnswer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor, // Buton rengini accentColor olarak ayarladık
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.1,
                          vertical: screenHeight * 0.02),
                    ),
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
