import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/notes_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._constructor();

  factory DatabaseService() => _instance;
  DatabaseService._constructor();

  static Database? _database;

  final String _tableName = 'myNotes';
  final String _noteId = 'id';
  final String _noteTitle = 'title';
  final String _noteContent = 'content';
  final String _noteColor = 'color';
  final String _noteDatetime = 'dateTime';

  Future<Database> get database async => _database ??= await getDatabase();

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, 'my_notes.db');
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: _onCreate,
    );

    return database;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE $_tableName (
          $_noteId INTEGER PRIMARY KEY AUTOINCREMENT,
          $_noteTitle TEXT,
          $_noteContent TEXT,
          $_noteColor TEXT,
          $_noteDatetime TEXT
        )
      ''');
  }

  Future<int> insertNote(Note note) async {
    final db = await database;
    return await db.insert(
      _tableName,
      note.toMap(),
    );
  }

  Future<List<Note>> getNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (index) => Note.fromMap(maps[index]));
  }

  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      _tableName,
      note.toMap(),
      where: '$_noteId = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete(
      _tableName,
      where: '$_noteId = ?',
      whereArgs: [id],
    );
  }

  Future<List<Note>> searchNote(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: '$_noteTitle LIKE ?',
      whereArgs: ['%$query%'],
    );

    return maps.map((map) => Note.fromMap(map)).toList();
  }
}
