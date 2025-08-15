class DebtEntry {
  DateTime date;
  String description;
  double amount;

  DebtEntry({
    required this.date,
    required this.description,
    required this.amount,
  });
}

class PersonDebt {
  int? id; // thêm id để quản lý trong DB
  String name;
  List<DebtEntry> debts;

  PersonDebt({
    this.id,
    required this.name,
    required this.debts,
  });

  double get totalDebt => debts.fold(0, (sum, e) => sum + e.amount);
}