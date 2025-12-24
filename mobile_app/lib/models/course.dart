class Course {
  final int id;
  final String name;
  final String description;
  final String lecturer;

  Course({required this.id, required this.name, required this.description, required this.lecturer});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['ID'],
      name: json['name'],
      description: json['description'],
      lecturer: json['lecturer'] ?? "N/A",
    );
  }
}