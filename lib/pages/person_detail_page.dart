import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/debt_models.dart';
import '../db/db_helper.dart';

class PersonDetailPage extends StatefulWidget {
  final PersonDebt person;
  final VoidCallback onUpdate;

  PersonDetailPage({required this.person, required this.onUpdate});

  @override
  State<PersonDetailPage> createState() => _PersonDetailPageState();
}

class _PersonDetailPageState extends State<PersonDetailPage> {
  final db = DBHelper();

  void _addDebt() {
    TextEditingController descController = TextEditingController();
    TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Thêm khoản nợ"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: descController,
              decoration: InputDecoration(hintText: "Nội dung nợ"),
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(hintText: "Số tiền"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (descController.text.isNotEmpty &&
                  amountController.text.isNotEmpty) {
                double amount = double.tryParse(amountController.text) ?? 0;

                var entry = DebtEntry(
                  date: DateTime.now(),
                  description: descController.text,
                  amount: amount,
                );

                // Thêm vào person hiện tại
                widget.person.debts.add(entry);

                // Lưu lại vào Hive
                final box = db.getPeopleBox();
                await box.put(widget.person.key, widget.person);

                widget.onUpdate();
                Navigator.pop(context);
                setState(() {}); // refresh UI
              }
            },
            child: Text("Lưu"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var debts = widget.person.debts;
    return Scaffold(
      appBar: AppBar(
        title: Text("Nợ của ${widget.person.name}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text("Ngày")),
                  DataColumn(label: Text("Nội dung")),
                  DataColumn(label: Text("Số tiền")),
                ],
                rows: debts.map((d) {
                  return DataRow(cells: [
                    DataCell(Text("${d.date.day}/${d.date.month}/${d.date.year}")),
                    DataCell(Text(d.description)),
                    DataCell(Text("${d.amount.toStringAsFixed(0)} đ")),
                  ]);
                }).toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "Tổng nợ: ${widget.person.totalDebt.toStringAsFixed(0)} đ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDebt,
        child: Icon(Icons.add),
      ),
    );
  }
}
