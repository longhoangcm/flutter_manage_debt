import 'package:hive/hive.dart';

part 'debt_models.g.dart'; // file này sẽ được tạo bởi build_runner

@HiveType(typeId: 0)
class DebtEntry extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  String description;

  @HiveField(2)
  double amount;

  DebtEntry({
    required this.date,
    required this.description,
    required this.amount,
  });
}

@HiveType(typeId: 1)
class PersonDebt extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<DebtEntry> debts;

  PersonDebt({
    required this.name,
    required this.debts,
  });

  // ✅ Getter tính tổng nợ
  double get totalDebt {
    return debts.fold(0, (sum, d) => sum + d.amount);
  }
}
