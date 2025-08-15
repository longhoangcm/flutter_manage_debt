import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/debt_models.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'note_debt.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE person (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE debt (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            personId INTEGER,
            date TEXT,
            description TEXT,
            amount REAL,
            FOREIGN KEY(personId) REFERENCES person(id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }

  Future<int> insertPerson(String name) async {
    final db = await database;
    return await db.insert('person', {'name': name});
  }

  Future<List<PersonDebt>> getAllPeople() async {
    final db = await database;
    List<Map<String, dynamic>> personRows = await db.query('person');
    List<PersonDebt> people = [];

    for (var p in personRows) {
      final debtRows = await db.query('debt', where: 'personId = ?', whereArgs: [p['id']]);
      List<DebtEntry> debts = debtRows.map((d) {
        return DebtEntry(
          // date: DateTime.parse(d['date']),
          // description: d['description'],
          // amount: d['amount'],
          date: DateTime.parse(d['date'] as String),
          description: d['description'] as String,
          amount: (d['amount'] as num).toDouble(),
        );
      }).toList();

      people.add(PersonDebt(
        id: p['id'],
        name: p['name'],
        debts: debts,
      ));
    }
    return people;
  }

  Future<int> insertDebt(int personId, DebtEntry entry) async {
    final db = await database;
    return await db.insert('debt', {
      'personId': personId,
      'date': entry.date.toIso8601String(),
      'description': entry.description,
      'amount': entry.amount
    });
  }
}
