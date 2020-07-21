import 'package:flutter/material.dart';
import 'package:emp_images_db/model/employee.dart';
import 'package:emp_images_db/services/employee_operations.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditEmployee extends StatefulWidget {
  final Employee employee;

  EditEmployee({this.employee});

  @override
  _EditEmployeeState createState() => _EditEmployeeState();
}

class _EditEmployeeState extends State<EditEmployee> {
  Employee employee;
  TextEditingController nameController = TextEditingController();
  TextEditingController postController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  File imagePath;

  @override
  void initState() {
    super.initState();
    employee = widget.employee;

    nameController.text = employee.name;
    postController.text = employee.post;
    salaryController.text = employee.salary.toString();

    if (employee.image != null) {
      imagePath = File(employee.image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Employee'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: <Widget>[
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 1, color: Colors.grey),
            ),
            child: imagePath == null
                ? Center(
                    child: Text('Select Image'),
                  )
                : Image.file(imagePath),
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () {
              captureImage();
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
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Salary'),
          ),
          SizedBox(height: 16),
          RaisedButton(
            child: Text('Edit Employee'),
            onPressed: () {
              editEmployeeToTable(context);
            },
          )
        ],
      ),
    );
  }

  void captureImage() async {
    ImagePicker picker = ImagePicker();
    PickedFile pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        imagePath = File(pickedFile.path);
      });
    }
  }

  void editEmployeeToTable(BuildContext context) async {
    String n = nameController.text;
    String p = postController.text;
    int s = int.parse(salaryController.text);
    String image;

    if (imagePath != null) {
      image = imagePath.path;
    }

    Employee e =
        Employee(id: employee.id, name: n, post: p, salary: s, image: image);

    await EmployeeOperations.instance.updateEmployee(e);
    Navigator.pop(context);
  }
}
