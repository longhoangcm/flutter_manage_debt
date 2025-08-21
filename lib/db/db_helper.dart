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

  Future<void> deletePerson(int index) async {
    await _peopleBox!.deleteAt(index);
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

   Future<void> deleteDebt(int personIndex, int debtIndex) async {
    final person = _peopleBox!.getAt(personIndex);

    if (person != null) {
      final debts = List<DebtEntry>.from(person.debts); // clone list cũ
      debts.removeAt(debtIndex); // xoá

      final updatedPerson = PersonDebt(
        name: person.name,
        debts: debts,
      );

      await _peopleBox!.putAt(personIndex, updatedPerson); // ghi đè lại Person
    }
  }

  PersonDebt? getPerson(int index) {
    return _peopleBox!.getAt(index);
  }
}
