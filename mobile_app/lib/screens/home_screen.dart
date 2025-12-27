import 'package:flutter/material.dart';
import 'package:mobile_app/screens/add_student_screen.dart';
import 'package:mobile_app/screens/course_list_screen.dart';
import 'package:mobile_app/screens/student_details_screen.dart';
import '../services/api_service.dart';
import '../models/student.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Student> allStudents = [];
  List<Student> filteredStudents = [];
  bool isLoading = true;
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // දත්ත Load කරන Function එක
  void _loadData() async {
    setState(() => isLoading = true);
    try {
      final students = await ApiService().fetchStudents();
      setState(() {
        allStudents = students;
        filteredStudents = students;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print("Error loading students: $e");
    }
  }

  // Search කරන විට ලිස්ට් එක Filter කරන Function එක
  void _filterStudents(String query) {
    setState(() {
      filteredStudents = allStudents
          .where(
            (student) =>
                student.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FB),
      appBar: AppBar(
        // සර්ච් කරනවා නම් TextField එක පෙන්වනවා, නැත්නම් Title එක පෙන්වනවා
        title: isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search student name...",
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: _filterStudents,
              )
            : Text(
                "Smart Campus",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
        backgroundColor: Colors.indigo,
        elevation: 0,
        actions: [
          // Search Icon එක
          IconButton(
            icon: Icon(
              isSearching ? Icons.close : Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  _searchController.clear();
                  filteredStudents = allStudents;
                }
              });
            },
          ),
          // Course List Icon එක
          IconButton(
            icon: Icon(Icons.book, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CourseListScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome Back,",
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "Student Dashboard",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                // පොඩි Stats පේළියක් (Optional)
                Text(
                  "Total Students: ${allStudents.length}",
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
            child: Text(
              isSearching ? "Search Results" : "All Students",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // දත්ත පෙන්වන කොටස
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : filteredStudents.isEmpty
                ? Center(
                    child: Text(
                      "No students found!",
                      style: GoogleFonts.poppins(),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async => _loadData(),
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      itemCount: filteredStudents.length,
                      itemBuilder: (context, index) {
                        var student = filteredStudents[index];
                        return GestureDetector(
                          onTap: () async {
                            bool? refresh = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    StudentDetailsScreen(student: student),
                              ),
                            );
                            if (refresh == true) _loadData();
                          },
                          child: Card(
                            elevation: 2,
                            margin: EdgeInsets.only(bottom: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.indigoAccent,
                                child: Text(
                                  student.name[0].toUpperCase(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(
                                student.name,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                "${student.courses.map((c) => c.name).join(', ')} | Age: ${student.age}",
                                style: GoogleFonts.poppins(fontSize: 13),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? refresh = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddStudentScreen()),
          );
          if (refresh == true) {
            _loadData(); // දත්ත අලුතින් Load කරනවා
          }
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.indigo,
      ),
    );
  }
}
