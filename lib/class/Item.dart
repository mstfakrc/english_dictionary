class Item {
  int? id;
  String questionDefinition = "";
  String answerWord = "";

  Item({this.id, required this.questionDefinition, required this.answerWord});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "questionDefinition": questionDefinition,
      "answerWord": answerWord
    };
  }
}
