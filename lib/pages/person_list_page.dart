import 'package:flutter/material.dart';
import '../models/debt_models.dart';
import 'person_detail_page.dart';
import '../db/db_helper.dart';

class PersonListPage extends StatefulWidget {
  @override
  State<PersonListPage> createState() => _PersonListPageState();
}

class _PersonListPageState extends State<PersonListPage> {
  List<PersonDebt> people = [];
  final db = DBHelper();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    var data = await db.getAllPeople();
    setState(() {
      people = data;
    });
  }

  void _addPerson() {
    TextEditingController nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Thêm người nợ"),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(hintText: "Tên người"),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                await db.insertPerson(nameController.text);
                _loadData();
              }
              Navigator.pop(context);
            },
            child: Text("Lưu"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Danh sách người nợ")),
      body: ListView.builder(
        itemCount: people.length,
        itemBuilder: (context, index) {
          var person = people[index];
          return Card(
            child: ListTile(
              title: Text(person.name),
              subtitle: Text("Tổng nợ: ${person.totalDebt.toStringAsFixed(0)} đ"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PersonDetailPage(
                      person: person,
                      onUpdate: _loadData,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPerson,
        child: Icon(Icons.add),
      ),
    );
  }
}
