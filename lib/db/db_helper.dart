import 'package:hive/hive.dart';
import '../models/debt_models.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  Box<PersonDebt>? _peopleBox;

  Future<void> init() async {
    _peopleBox = await Hive.openBox<PersonDebt>('peopleBox');
  }

  Box<PersonDebt> getPeopleBox() {
    if (_peopleBox == null) {
      throw Exception("Box chưa được mở. Hãy gọi DBHelper().init() trong main()");
    }
    return _peopleBox!;
  }

  Future<void> insertPerson(String name) async {
    final person = PersonDebt(name: name, debts: []);
    await _peopleBox!.add(person);
  }

  List<PersonDebt> getAllPeople() {
    return _peopleBox!.values.toList();
  }

  Future<void> insertDebt(int personKey, DebtEntry entry) async {
    final person = _peopleBox!.getAt(personKey);
    if (person != null) {
      person.debts.add(entry);
      await person.save(); // vì PersonDebt là HiveObject
    }
  }
}
