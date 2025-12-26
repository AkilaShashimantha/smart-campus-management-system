import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../models/course.dart';

class AddStudentScreen extends StatefulWidget {
  @override
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  
  int? _selectedCourseId; // තෝරාගත් Course ID එක තබා ගැනීමට
  List<Course> _courses = []; // Backend එකෙන් එන ලිස්ට් එක
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCourses(); // පිටුව Load වෙද්දීම Courses ටික ගේමු
  }

void _loadCourses() async {
  try {
    final data = await ApiService().fetchCourses();
    setState(() {
      _courses = data;
      _isLoading = false; // දත්ත ආවාම Loading නවත්වනවා
      if (_courses.isNotEmpty) {
        _selectedCourseId = _courses[0].id;
      }
    });
  } catch (e) {
    setState(() => _isLoading = false); // Error එකක් ආවත් Loading නවත්වන්න
    print("Error loading courses: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Courses load කිරීමට නොහැකි වුණා!"))
    );
  }
}

  void _submitData() async {
    if (_formKey.currentState!.validate() && _selectedCourseId != null) {
      final success = await ApiService().addStudent({
        "name": _nameController.text,
        "email": _emailController.text,
        "age": int.parse(_ageController.text),
        "course_ids": [_selectedCourseId], 
      });

      if (success) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error adding student!")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register Student", style: GoogleFonts.poppins())),
      body: _isLoading 
        ? Center(child: CircularProgressIndicator()) 
        : Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  _buildTextField(_nameController, "Full Name", Icons.person),
                  SizedBox(height: 15),
                  _buildTextField(_emailController, "Email Address", Icons.email),
                  SizedBox(height: 15),
                  _buildTextField(_ageController, "Age", Icons.cake, isNumber: true),
                  SizedBox(height: 15),

                  // --- Course Selection Dropdown ---
                  Text("Select Course", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    value: _selectedCourseId,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      prefixIcon: Icon(Icons.book),
                    ),
                    items: _courses.map((course) {
                      return DropdownMenuItem<int>(
                        value: course.id,
                        child: Text(course.name),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedCourseId = val),
                  ),
                  // --------------------------------

                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _submitData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text("Register Student", style: GoogleFonts.poppins(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) => value!.isEmpty ? "Please enter $label" : null,
    );
  }
}