import 'package:flutter/material.dart';
import 'pages/person_list_page.dart';

void main() {
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
