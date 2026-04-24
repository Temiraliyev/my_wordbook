// ignore_for_file: depend_on_referenced_packages

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/group.dart';
import '../models/word.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, 'words.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE groups (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE words (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            word TEXT,
            translation TEXT,
            groupId INTEGER
          )
        ''');
      },
    );
  }

  // 📌 GROUP METHODS
  Future<int> insertGroup(Group group) async {
    final db = await instance.database;
    return await db.insert('groups', group.toMap());
  }

  Future<List<Group>> getGroups() async {
    final db = await instance.database;
    final result = await db.query('groups');
    return result.map((map) => Group.fromMap(map)).toList();
  }

  Future<int> updateGroup(Group group) async {
    final db = await instance.database;
    return await db.update(
      'groups',
      group.toMap(),
      where: 'id = ?',
      whereArgs: [group.id],
    );
  }

  Future<int> deleteGroup(int id) async {
    final db = await instance.database;
    await db.delete('words', where: 'groupId = ?', whereArgs: [id]);
    return await db.delete('groups', where: 'id = ?', whereArgs: [id]);
  }

  // 📌 WORD METHODS
  Future<int> insertWord(Word word) async {
    final db = await instance.database;
    return await db.insert('words', word.toMap());
  }

  Future<List<Word>> getWordsByGroup(int groupId) async {
    final db = await instance.database;
    final result = await db.query(
      'words',
      where: 'groupId = ?',
      whereArgs: [groupId],
    );
    return result.map((map) => Word.fromMap(map)).toList();
  }

  Future<int> updateWord(Word word) async {
    final db = await instance.database;
    return await db.update(
      'words',
      word.toMap(),
      where: 'id = ?',
      whereArgs: [word.id],
    );
  }

  Future<int> deleteWord(int id) async {
    final db = await instance.database;
    return await db.delete('words', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> getWordCountInGroup(int groupId) async {
    final db = await instance.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM words WHERE groupId = ?',
      [groupId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
