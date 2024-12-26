import 'package:dictionaryenglish/class/Item.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  static Future<Database> _openDB() async {
    return openDatabase(join(await getDatabasesPath(), 'gamenft.db'),
        onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE item(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            word TEXT,
            definition TEXT
          ); 
        ''');
    }, version: 1);
  }

  static Future<void> insertItem(Item itemData) async {
    Database database = await _openDB();
    await database.rawInsert(
        "INSERT INTO item (word, definition) VALUES (?, ?)",
        [itemData.answerWord, itemData.questionDefinition]);
  }

  static Future<int> deleteItem(Item itemData) async {
    Database database = await _openDB();
    print(itemData.id);
    return database.delete("item", where: "id = ?", whereArgs: [itemData.id]);
  }

  //LECTURA

  static Future<List<Item>> readItem() async {
    Database database = await _openDB();
    final List<Map<String, dynamic>> itemMap = await database.query("item");

    return List.generate(
        itemMap.length,
        (i) => Item(
              id: itemMap[i]['id'],
              answerWord: itemMap[i]['word'],
              questionDefinition: itemMap[i]['definition'],
            ));
  }
}
