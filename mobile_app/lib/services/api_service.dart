import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/models/course.dart';
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

  Future<Student> fetchStudentById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/students/$id'));

    if (response.statusCode == 200) {
      return Student.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load student details");
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

// ශිෂ්‍යයෙකු මකා දැමීමේ function එක
Future<bool> deleteStudent(int id) async {
  try {
    final response = await http.delete(
      Uri.parse('$baseUrl/students/$id'),
      headers: {"Content-Type": "application/json"},
    );

    
    if (response.statusCode == 200) {
      return true;
    } else {
      print("Delete failed: ${response.body}");
      return false;
    }
  } catch (e) {
    print("Error deleting student: $e");
    return false;
  }
}

// සියලුම Courses ලබාගැනීම
Future<List<Course>> fetchCourses() async {
  final response = await http.get(Uri.parse('$baseUrl/courses'));
  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    return body.map((item) => Course.fromJson(item)).toList();
  } else {
    throw Exception("Failed to load courses");
  }
}

// Course එකක් ඇතුළත් කිරීම හෝ Update කිරීම
Future<bool> saveCourse(Map<String, dynamic> data, {int? id}) async {
  final url = id == null ? '$baseUrl/courses' : '$baseUrl/courses/$id';
  final response = id == null 
      ? await http.post(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: jsonEncode(data))
      : await http.put(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: jsonEncode(data));

  return response.statusCode == 200 || response.statusCode == 201;
}

// Course එකක් Delete කිරීම
Future<bool> deleteCourse(int id) async {
  final response = await http.delete(Uri.parse('$baseUrl/courses/$id'));
  return response.statusCode == 200;
}

  // Student enrollment
  Future<bool> enrollStudent(int studentId, int courseId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/students/enroll'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "student_id": studentId,
        "course_id": courseId,
      }),
    );
    return response.statusCode == 200;
  }
}