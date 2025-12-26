import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/student.dart';
import '../models/course.dart';
import '../services/api_service.dart';

class StudentDetailsScreen extends StatefulWidget {
  final Student student;
  StudentDetailsScreen({required this.student});

  @override
  _StudentDetailsScreenState createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  late Student _student;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _student = widget.student;
  }

  // Reload student details to see updated courses
  Future<void> _refreshStudent() async {
    setState(() => _isLoading = true);
    try {
      final updatedStudent = await ApiService().fetchStudentById(_student.id);
      setState(() {
        _student = updatedStudent;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print("Error refreshing student: $e");
    }
  }

  Future<void> _showEnrollDialog() async {
    // 1. Fetch available courses
    List<Course> allCourses = [];
    try {
      allCourses = await ApiService().fetchCourses();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to load courses")));
      return;
    }

    int? selectedCourseId;
    if (allCourses.isNotEmpty) selectedCourseId = allCourses[0].id;

    if (allCourses.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No courses available to enroll")));
        return;
    }

    showDialog(
      context: context,
      builder: (context) {
        int? tempSelectedId = selectedCourseId;
        return StatefulBuilder(
          builder: (context, setStateBd) {
            return AlertDialog(
              title: Text("Enroll in New Course"),
              content: DropdownButton<int>(
                value: tempSelectedId,
                isExpanded: true,
                items: allCourses.map((c) => DropdownMenuItem(
                  value: c.id,
                  child: Text(c.name),
                )).toList(),
                onChanged: (val) {
                  setStateBd(() => tempSelectedId = val);
                },
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
                TextButton(
                  onPressed: () async {
                    if (tempSelectedId != null) {
                      Navigator.pop(context); // Close dialog
                      final success = await ApiService().enrollStudent(_student.id, tempSelectedId!);
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enrolled successfully!")));
                        _refreshStudent(); // Refresh UI
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enrollment failed!")));
                      }
                    }
                  },
                  child: Text("Enroll"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true); // Return true to refresh home screen
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_student.name, style: GoogleFonts.poppins()),
          actions: [
            IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => _confirmDelete(context)),
          ],
        ),
        body: _isLoading 
            ? Center(child: CircularProgressIndicator())
            : Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoTile("Email", _student.email, Icons.email),
              _infoTile("Age", _student.age.toString(), Icons.cake),
              SizedBox(height: 20),
              Text("Enrolled Courses", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
              Divider(),
              Expanded(
                child: _student.courses.isEmpty
                    ? Center(child: Text("No enrolled courses", style: TextStyle(color: Colors.grey)))
                    : ListView.builder(
                        itemCount: _student.courses.length,
                        itemBuilder: (context, index) => Card(
                          child: ListTile(
                            leading: Icon(Icons.book, color: Colors.indigo),
                            title: Text(_student.courses[index].name),
                            subtitle: Text(_student.courses[index].lecturer),
                          ),
                        ),
                      ),
              ),
              ElevatedButton.icon(
                onPressed: _showEnrollDialog,
                icon: Icon(Icons.add),
                label: Text("Enroll in New Course"),
                style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoTile(String label, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.indigo),
      title: Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
      subtitle: Text(value, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Delete Student?"),
        content: Text("This action cannot be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text("Cancel")),
          TextButton(onPressed: () async {
            await ApiService().deleteStudent(_student.id);
            Navigator.pop(ctx);
            Navigator.pop(context, true);
          }, child: Text("Delete", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}