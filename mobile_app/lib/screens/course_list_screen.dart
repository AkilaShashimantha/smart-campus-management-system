import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/course.dart';
import '../services/api_service.dart';
import 'course_form_screen.dart';

class CourseListScreen extends StatefulWidget {
  @override
  _CourseListScreenState createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  late Future<List<Course>> _futureCourses;

  @override
  void initState() {
    super.initState();
    _refreshCourses();
  }

  void _refreshCourses() {
    setState(() {
      _futureCourses = ApiService().fetchCourses();
    });
  }

  void _deleteCourse(int id) async {
    bool success = await ApiService().deleteCourse(id);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Course deleted")));
      _refreshCourses();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Courses", style: GoogleFonts.poppins()),
        backgroundColor: Colors.indigo,
      ),
      body: FutureBuilder<List<Course>>(
        future: _futureCourses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No courses found. Add one!"));
          }

          return ListView.builder(
            padding: EdgeInsets.all(15),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var course = snapshot.data![index];
              return Card(
                elevation: 3,
                margin: EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  contentPadding: EdgeInsets.all(15),
                  title: Text(course.name, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Lecturer: ${course.lecturer}", style: GoogleFonts.poppins(color: Colors.indigo)),
                      SizedBox(height: 5),
                      Text(course.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Edit Button
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          bool? updated = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CourseFormScreen(course: course)),
                          );
                          if (updated == true) _refreshCourses();
                        },
                      ),
                      // Delete Button
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _showDeleteDialog(course.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? added = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CourseFormScreen()),
          );
          if (added == true) _refreshCourses();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.indigo,
      ),
    );
  }

  void _showDeleteDialog(int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Delete Course"),
        content: Text("Are you sure you want to delete this course? This will affect students enrolled in it."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deleteCourse(id);
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}