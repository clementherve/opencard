import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:opencard/page/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final db = Localstore.instance;
    return MaterialApp(
      title: 'OpenCard',
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: HomePage(db),
    );
  }
}
