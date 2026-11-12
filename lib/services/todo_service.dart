import 'dart:convert';
import 'package:http/http.dart' as http;

class ToDoService {
  static const String baseUrl = 'https://api.nstack.in/v1/todos';

  // GET: mengambil data ToDo
  static Future<List<dynamic>?> fetchTodo() async {
    try {
      final uri = Uri.parse('$baseUrl?page=1&limit=10');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return json['items'] as List<dynamic>;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // POST: menambahkan ToDo baru
  static Future<bool> addToDo(Map<String, dynamic> body) async {
    try {
      final uri = Uri.parse(baseUrl);

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      return response.statusCode == 201 ||
          response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // PUT: mengubah data ToDo berdasarkan ID
  static Future<bool> updateToDo(
    String id,
    Map<String, dynamic> body,
  ) async {
    try {
      final uri = Uri.parse('$baseUrl/$id');

      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // DELETE: menghapus data berdasarkan ID
  static Future<bool> deleteById(String id) async {
    try {
      final uri = Uri.parse('$baseUrl/$id');
      final response = await http.delete(uri);

      return response.statusCode == 200 ||
          response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }
}