// import 'package:expense_tracker/Homepage.dart';
import 'package:expense_tracker/google_sheets_api.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/homepage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleSheetsApi().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HompePage(),
    );
  }
}

