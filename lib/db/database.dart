import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "routines_app.db";
  static final _databaseVersion = 1;

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Frequency (
        id INTEGER PRIMARY KEY,
        label TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE State (
        id INTEGER PRIMARY KEY,
        label TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE Routine (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        startDate TEXT NOT NULL,
        endDate TEXT,
        icon TEXT NOT NULL,
        description TEXT,
        alert TEXT,
        frequencyId INTEGER NOT NULL,
        recurrence INTEGER NOT NULL,
        days TEXT NOT NULL,
        FOREIGN KEY (frequencyId) REFERENCES Frequency (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE Completion (
        id INTEGER PRIMARY KEY,
        stateId INTEGER NOT NULL,
        description TEXT,
        image TEXT,
        routineId INTEGER NOT NULL,
        FOREIGN KEY (stateId) REFERENCES State (id),
        FOREIGN KEY (routineId) REFERENCES Routine (id)
      )
    ''');
  }
}
