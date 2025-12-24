import 'package:flutter/material.dart';
import 'package:mobile_app/screens/add_student_screen.dart';
import 'package:mobile_app/screens/course_list_screen.dart';
import '../services/api_service.dart';
import '../models/student.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Student>> futureStudents;

  @override
  void initState() {
    super.initState();
    futureStudents = ApiService().fetchStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FB), // ලස්සන Off-white පාටක්
      appBar: AppBar(
        title: Text("Smart Campus", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.indigo,
        elevation: 0,
        actions: [
  IconButton(
    icon: Icon(Icons.book, color: Colors.white),
    onPressed: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => CourseListScreen()));
    },
  )
],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card එක
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 73, 87, 171),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome Back,", style: GoogleFonts.poppins(color: Colors.white70, fontSize: 16)),
                Text("Student Dashboard", style: GoogleFonts.poppins(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text("All Students", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
          ),

          // දත්ත පෙන්වන කොටස
          Expanded(
            child: FutureBuilder<List<Student>>(
              future: futureStudents,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("No students found."));
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var student = snapshot.data![index];
                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.only(bottom: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.indigoAccent,
                          child: Text(student.name[0], style: TextStyle(color: Colors.white)),
                        ),
                        title: Text(student.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                        subtitle: Text("${student.courseName} | Age: ${student.age}"),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      
      // අලුත් ශිෂ්‍යයෙක් එකතු කිරීමට Floating Button එකක්
floatingActionButton: FloatingActionButton(
  onPressed: () async {
    // Add Screen එකට ගිහින් ආපසු එනකම් ඉන්නවා
    bool? refresh = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddStudentScreen()),
    );

    // දත්ත ඇතුළත් කළා නම් ලිස්ට් එක Refresh කරනවා
    if (refresh == true) {
      setState(() {
        futureStudents = ApiService().fetchStudents();
      });
    }
  },
  child: Icon(Icons.add),
  backgroundColor: Colors.indigo,
),
    );
  }
}