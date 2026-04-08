import 'package:flutter/material.dart';
import 'dashboard_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});
  @override
  Widget build(BuildContext context){
    return MaterialApp(title: 'app', debugShowCheckedModeBanner: false, theme: ThemeData(primarySwatch: Colors.blue,), home: const DashboardPage(),);
  }
}


