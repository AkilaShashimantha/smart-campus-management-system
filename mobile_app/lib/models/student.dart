class Student {
  final int id;
  final String name;
  final String email;
  final int age;
  final String courseName; // Course එකේ නම පෙන්වන්න

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.courseName,
  });

  // JSON එකක් Student object එකකට හරවන හැටි
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['ID'],
      name: json['name'],
      email: json['email'],
      age: json['age'],
      courseName: json['Course'] != null ? json['Course']['name'] : 'No Course',
    );
  }
}