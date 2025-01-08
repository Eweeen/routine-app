import 'package:routine_app/db/seed/routineSeed.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "routines_app.db";
  static final _databaseVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

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

    await _seed(db);
  }

  Future<void> _seed(Database db) async {
    await db.insert('Frequency', {'id': 1, 'label': 'Quotidienne'});
    await db.insert('Frequency', {'id': 2, 'label': 'Hebdomadaire'});
    await db.insert('Frequency', {'id': 3, 'label': 'Mensuelle'});
    await db.insert('Frequency', {'id': 4, 'label': 'Annuelle'});
    await db.insert('Frequency', {'id': 5, 'label': 'Une fois'});
  }

  // Méthodes pour gérer les données des routines
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

  // Méthodes pour gérer les données des complétions
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
  // Insérer plusieurs routines
  Future<void> insertFakeRoutines(int count) async {
    final db = await database;
    final faker = RoutineFaker();
    final fakeRoutines = faker.generateFakeRoutines(count);

    Batch batch = db.batch();
    for (final routine in fakeRoutines) {
      batch.insert('Routine', {
        'id': routine.id,
        'name': routine.name,
        'startDate': routine.startDate.toIso8601String(),
        'endDate': routine.endDate?.toIso8601String(),
        'icon': routine.icon,
        'description': routine.description,
        'alert': routine.alert,
        'frequencyId': routine.frequency.id,
        'recurrence': routine.recurrence,
        'days': routine.days.join(','), // Stocké sous forme de chaîne
      });
    }
    await batch.commit();
  }
}
