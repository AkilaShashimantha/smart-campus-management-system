import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student.dart';

//192.168.8.114

class ApiService {
  static const String baseUrl = "http://192.168.8.114:8080/api/v1";

  Future<List<Student>> fetchStudents() async {
    final response = await http.get(Uri.parse('$baseUrl/students'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((item) => Student.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load students");
    }
  }

Future<bool> addStudent(Map<String, dynamic> studentData) async {
  final response = await http.post(
    Uri.parse('$baseUrl/students'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(studentData),
  );

  return response.statusCode == 201;
}

}