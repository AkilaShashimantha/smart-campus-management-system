import 'course.dart';

class Student {
  final int id;
  final String name;
  final String email;
  final int age;
  final List<Course> courses;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.courses,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['ID'] ?? 0,
      name: json['name'] ?? 'Unknown',
      email: json['email'] ?? '',
      age: json['age'] ?? 0,
      courses: (json['courses'] as List<dynamic>?)
              ?.map((i) => Course.fromJson(i as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}