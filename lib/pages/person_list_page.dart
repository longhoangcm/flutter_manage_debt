import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/debt_models.dart';
import 'person_detail_page.dart';
import '../db/db_helper.dart';

class PersonListPage extends StatefulWidget {
  @override
  State<PersonListPage> createState() => _PersonListPageState();
}

class _PersonListPageState extends State<PersonListPage> {
  final db = DBHelper();

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
                final box = db.getPeopleBox();
                final person = PersonDebt(name: nameController.text, debts: []);
                await box.add(person); // thêm vào Hive
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
    final box = db.getPeopleBox();

    return Scaffold(
      appBar: AppBar(title: Text("Danh sách người nợ")),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<PersonDebt> box, _) {
          final people = box.values.toList();

          if (people.isEmpty) {
            return Center(child: Text("Chưa có dữ liệu"));
          }

          return ListView.builder(
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
                          personIndex: index,
                          person: person,
                          onUpdate: () => setState(() {}),
                        ),
                      ),
                    );
                  },
                  // trailing: IconButton(
                  //   icon: const Icon(Icons.delete, color: Colors.red),
                  //   onPressed:
                  onLongPress: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) =>
                        AlertDialog(
                          title: Text("Xóa nợ này?"),
                          content: Text(
                              "Bạn có chắc muốn xóa đối tượng: ${person.name}?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: Text("Hủy"),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: Text("Xóa"),
                            ),
                          ],
                        ),
                    );
                    if (confirm == true) {
                      await db.deletePerson(index);
                    }
                  },
                  // ),
                ),
              );
            },
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
