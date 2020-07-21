import 'dart:io';

import 'package:emp_images_db/screens/add_employee.dart';
import 'package:emp_images_db/screens/edit_employee.dart';
import 'package:flutter/material.dart';
import 'package:emp_images_db/model/employee.dart';
import 'package:emp_images_db/services/employee_operations.dart';
import 'package:emp_images_db/services/jump_to_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Employee> employeeList = [];

  void getEmployees() async {
    List<Employee> temp = await EmployeeOperations.instance.getAllEmployees();

    setState(() {
      employeeList = temp;
    });
  }

  @override
  void initState() {
    getEmployees();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Employee Demo')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          jumpToAddEmployee(context);
        },
      ),
      body: employeeList.length == 0
          ? NoData()
          : ShowData(employeeList: employeeList),
    );
  }

  void jumpToAddEmployee(BuildContext context) async {
    await JumpToPage.push(context, AddEmployee());
    getEmployees();
  }
}

class NoData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('No Data to display'));
  }
}

class ShowData extends StatefulWidget {
  List<Employee> employeeList;

  ShowData({this.employeeList});

  @override
  _ShowDataState createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.employeeList.length,
      itemBuilder: (BuildContext context, index) {
        //get index employee form list
        Employee employee = widget.employeeList[index];

        //design the widget
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading:
                employee.image == null ? getText(employee) : getImage(employee),
            title: Text(employee.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(employee.post),
                Text('\u20B9${employee.salary}'),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await EmployeeOperations.instance.deleteEmployee(employee);
                List<Employee> temp =
                    await EmployeeOperations.instance.getAllEmployees();
                setState(() {
                  widget.employeeList = temp;
                });
              },
            ),
            onTap: () async {
              await JumpToPage.push(
                context,
                EditEmployee(employee: employee),
              );
              List<Employee> temp =
                  await EmployeeOperations.instance.getAllEmployees();
              setState(() {
                widget.employeeList = temp;
              });
            },
          ),
        );
      },
    );
  }

  Widget getText(Employee employee) {
    return CircleAvatar(
      child: Text(employee.name[0]),
    );
  }

  Widget getImage(Employee employee) {
    return CircleAvatar(
      backgroundImage: FileImage(File(employee.image)),
    );
  }
}
