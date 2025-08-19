import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/debt_models.dart';
import 'db/db_helper.dart';
import 'pages/person_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(DebtEntryAdapter());
  Hive.registerAdapter(PersonDebtAdapter());

  await DBHelper().init();

  runApp(DebtApp());
}

class DebtApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ghi chú nợ',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PersonListPage(),
    );
  }
}
