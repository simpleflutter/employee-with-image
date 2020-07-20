import 'dart:io';
import 'package:flutter/material.dart';
import 'package:emp_images_db/model/employee.dart';
import 'package:emp_images_db/services/employee_operations.dart';
import 'package:image_picker/image_picker.dart';

class AddEmployee extends StatefulWidget {
  @override
  _AddEmployeeState createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController postController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();

  File imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Employee')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Container(
              height: 300,
              padding: EdgeInsets.all(3),
              child: imageFile == null
                  ? Center(
                      child: Text('Select Image'),
                    )
                  : Image.file(
                      imageFile,
                      fit: BoxFit.cover,
                    ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
              ),
            ),
            SizedBox(height: 16),
            IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: () {
                capatureImage();
              },
            ),
            TextField(
              controller: nameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(hintText: 'Name'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: postController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(hintText: 'Post'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: salaryController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(hintText: 'Salary'),
            ),
            SizedBox(height: 16),
            RaisedButton(
              child: Text('Add Employee'),
              onPressed: () {
                addEmployeeToTable(context);
              },
            )
          ],
        ),
      ),
    );
  }

  void addEmployeeToTable(BuildContext context) async {
    String n = nameController.text;
    String p = postController.text;
    int s = int.parse(salaryController.text);

    String imagePath;

    if (imageFile != null) {
      imagePath = imageFile.path;
    }

    Employee e = Employee(name: n, post: p, salary: s, image: imagePath);
    await EmployeeOperations.instance.insertEmployee(e);
    Navigator.pop(context);
  }

  void capatureImage() async {
    ImagePicker picker = ImagePicker();
    PickedFile pickedFile = await picker.getImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }
}
