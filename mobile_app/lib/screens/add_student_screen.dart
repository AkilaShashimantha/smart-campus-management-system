import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';

class AddStudentScreen extends StatefulWidget {
  @override
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  int _selectedCourseId = 1; // දැනට hardcoded, පසුව මෙය Backend එකෙන් ගමු

  void _submitData() async {
    if (_formKey.currentState!.validate()) {
      final success = await ApiService().addStudent({
        "name": _nameController.text,
        "email": _emailController.text,
        "age": int.parse(_ageController.text),
        "course_id": _selectedCourseId,
      });

      if (success) {
        Navigator.pop(context, true); // සාර්ථකයි නම් ආපසු Dashboard එකට
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error adding student!")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add New Student", style: GoogleFonts.poppins())),
      body: Padding(
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
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("Register Student", style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
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