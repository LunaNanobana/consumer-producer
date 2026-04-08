
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  static const String baseUrl = 'http://10.0.2.2:8000'; 

  static String? token;

  static Map<String, String> get headers {
  final h = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  if (token != null) h['Authorization'] = 'Token $token'; 
  return h;
}

  // LOGIN
  Future<Map<String, dynamic>> login(String email, String password, String role) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/login/'), 
      headers: headers,
      body: jsonEncode({
        'email': email,
        'password': password,
        'role': role, 
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      token = data['token']; 
      return data;
    } else {
      throw data['detail'] ?? data['message'] ?? 'Login failed';
    }
  }

Future<List<dynamic>> getProducts() async {
  final response = await http.get(
    Uri.parse('$baseUrl/api/products/'),
    headers: headers,
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load products');
  }
}

Future<List<dynamic>> getSuppliers() async {
  final response = await http.get(
    Uri.parse('$baseUrl/api/suppliers/'),
    headers: headers,
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load suppliers');
  }
}



  // REGISTER
Future<Map<String, dynamic>> register({
  
  required String name,
  required String email,
  required String password,
  required String role,
  String? businessName,
  String? phone,
}) async {
  final response = await http.post(
    Uri.parse('$baseUrl/api/register/'),
    headers: headers,
body: jsonEncode({
  'name': name,
  'email': email,
  'password': password,
  'role': role,
  'business_name': businessName ?? "",
  'phone': phone ?? "",
})
  );

  final data = jsonDecode(response.body);
  if (response.statusCode == 200 || response.statusCode == 201) {
  
    token = data['token'];
    return data;
  } else {
    throw data['detail'] ?? data['message'] ?? 'Registration failed';
  }
}



  // Send link request

Future<void> sendLinkRequest(String supplierId) async {
  final int? id = int.tryParse(supplierId);
  if (id == null) {
    throw Exception("Invalid supplier ID");
  }

  final response = await http.post(
    Uri.parse('$baseUrl/api/link/request/'),
    headers: headers,
    body: jsonEncode({
      "supplier_id": id,
    }),
  );

  if (response.statusCode == 201 || response.statusCode == 200) {
    return;
  } else {
    print('API Error: ${response.statusCode} ${response.body}');
    throw Exception('Failed to send request: ${response.body}');
  }
}



}


Future<void> saveTokenToPrefs(String tokenStr) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('auth_token', tokenStr);
}

Future<String?> loadTokenFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('auth_token');
}

