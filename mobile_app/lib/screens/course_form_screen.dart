import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/api_service.dart';

class CourseFormScreen extends StatefulWidget {
  final Course? course; 
  CourseFormScreen({this.course});

  @override
  _CourseFormScreenState createState() => _CourseFormScreenState();
}

class _CourseFormScreenState extends State<CourseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _lecturerController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.course?.name ?? "");
    _descController = TextEditingController(text: widget.course?.description ?? "");
    _lecturerController = TextEditingController(text: widget.course?.lecturer ?? "");
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        "name": _nameController.text,
        "description": _descController.text,
        "lecturer": _lecturerController.text,
      };
      
      bool success = await ApiService().saveCourse(data, id: widget.course?.id);
      if (success) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.course == null ? "Add Course" : "Edit Course")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _nameController, decoration: InputDecoration(labelText: "Course Name")),
              TextFormField(controller: _descController, decoration: InputDecoration(labelText: "Description")),
              TextFormField(controller: _lecturerController, decoration: InputDecoration(labelText: "Lecturer Name")),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _save, child: Text("Save Course"))
            ],
          ),
        ),
      ),
    );
  }
}