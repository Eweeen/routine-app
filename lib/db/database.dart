import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "routines_app.db";
  static final _databaseVersion = 1;

  // Singleton instance
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Database reference
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // Create database schema
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
        id INTEGER PRIMARY KEY AUTOINCREMENT,
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
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        stateId INTEGER NOT NULL,
        description TEXT,
        image TEXT,
        routineId INTEGER NOT NULL,
        FOREIGN KEY (stateId) REFERENCES State (id),
        FOREIGN KEY (routineId) REFERENCES Routine (id)
      )
    ''');

    // Seed the database
    await _seedDatabase(db);
  }

  // Seed initial data
  Future<void> _seedDatabase(Database db) async {
    // Insert frequencies
    await db.rawInsert('''
      INSERT INTO Frequency (id, label) VALUES
        (1, 'Quotidienne'),
        (2, 'Hebdomadaire'),
        (3, 'Mensuelle'),
        (4, 'Annuelle'),
        (5, 'Une fois')
    ''');

    // Insert states
    await db.rawInsert('''
      INSERT INTO State (id, label) VALUES
        (1, 'Non Complété'),
        (2, 'Partiellement Complété'),
        (3, 'Complété')
    ''');

    // Insert routines (optimized multi-line insert)
    await db.rawInsert('''
      INSERT INTO Routine (name, startDate, endDate, icon, description, alert, frequencyId, recurrence, days)
      VALUES
        ('Routine Matin', '2025-01-01', '2025-01-31', '☀️', 'Commencez votre journée avec de l’énergie.', NULL, 1, 1, '1,2,3,4,5'),
        ('Routine Soir', '2025-01-01', '2025-01-31', '🌙', 'Relaxez-vous après une longue journée.', NULL, 1, 1, '1,2,3,4,5'),
        ('Routine Lecture', '2025-01-01', '2025-01-15', '📚', 'Prenez du temps pour lire.', NULL, 3, 1, '6,7'),
        ('Routine Sport', '2025-01-01', '2025-01-20', '🏋️‍♀️', 'Restez en forme physiquement.', NULL, 2, 2, '1,3,5')
    ''');
  }

  // CRUD Operations for Routines
  Future<List<Map<String, dynamic>>> getRoutines() async {
    final db = await database;
    return await db.query('Routine');
  }

  Future<int> insertRoutine(Map<String, dynamic> routine) async {
    final db = await database;
    return await db.insert('Routine', routine);
  }

  Future<int> updateRoutine(int id, Map<String, dynamic> routine) async {
    final db = await database;
    return await db.update('Routine', routine, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteRoutine(int id) async {
    final db = await database;
    return await db.delete('Routine', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD Operations for Completions
  Future<List<Map<String, dynamic>>> getCompletions() async {
    final db = await database;
    return await db.query('Completion');
  }

  Future<int> insertCompletion(Map<String, dynamic> completion) async {
    final db = await database;
    return await db.insert('Completion', completion);
  }

  Future<int> updateCompletion(int id, Map<String, dynamic> completion) async {
    final db = await database;
    return await db.update('Completion', completion, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteCompletion(int id) async {
    final db = await database;
    return await db.delete('Completion', where: 'id = ?', whereArgs: [id]);
  }
}
