import 'dart:developer';
import "dart:math";
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:questions_for_couples/tools/app_constant.dart';
import 'package:questions_for_couples/models/Question.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  late Database _db;

  Future<Database> get db async {
    print("adil init");
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  refreshDb(path) async {
    bool idDb = await File(path).exists();

    if (true) {
      // delete existing if any
      await deleteDatabase(path);

// Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

// Copy from asset
      ByteData data = await rootBundle.load(join("assets", "questions.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await new File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("adil there is db");
    }
  }

  initDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "questions.db");
    print("adil " + path.toString());
    try {
      await refreshDb(path);
    } catch (e) {
      print("adil something happend");
    }

    var theDb = await openDatabase(path, version: 1, readOnly: false);
    return theDb;
  }

  Future<List<Question>> getRandomQuestion() async {
    var dbClient = await db;
    List<Map> list = await dbClient
        .rawQuery('SELECT * FROM questions ORDER BY RANDOM() LIMIT 1');

    List<Question> question = [];

    list.forEach((e) {
      question.add(new Question(
        id: e["id"],
        text: e["text"],
        tags: " ",
      ));
    });

    return question;
  }

  Future<List<Question>> getQuestionByTag(tags) async {
    var dbClient = await db;
    String idQuery = 'select id from questions ' + tags;
    List<Map> listId = await dbClient.rawQuery(idQuery);
    print("****************");
    print(idQuery);
    print("****************");
    var chosen = listId[Random().nextInt(listId.length - 1)];
    var chosenId = chosen['id'];
    String query = 'select * from questions where id= $chosenId';
    List<Map> list = await dbClient.rawQuery(query);

    List<Question> question = [];

    list.forEach((e) {
      question.add(new Question(
        id: e["id"],
        text: e["text"],
        tags: e["tags"],
      ));
    });

    return question;
  }
}
