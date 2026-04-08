// lib/main.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'role_selection_screen.dart';
import 'api_service.dart';
import 'main_providers.dart';   



Future<void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  // load saved token
  final prefs = await SharedPreferences.getInstance();
  ApiService.token = prefs.getString('auth_token');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: MaterialApp(
        title: 'SCP Food App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const RoleSelectionScreen(), 
      ),
    );
  }
}