import 'package:sqflite/sqflite.dart';
import 'package:emp_images_db/model/employee.dart';
import 'package:emp_images_db/services/db_helper.dart';
import 'dart:core';

class EmployeeOperations {
  EmployeeOperations._();

  static final EmployeeOperations instance = EmployeeOperations._();

  Future<int> insertEmployee(Employee employee) async {
    Database db = await DBHelper.instacne.database;
    return await db.insert('employees', employee.toMap());
  }

  Future<int> deleteEmployee(Employee employee) async {
    Database db = await DBHelper.instacne.database;
    return await db
        .delete('employees', where: 'id=?', whereArgs: [employee.id]);
  }

  Future<int> updateEmployee(Employee employee) async {
    Database db = await DBHelper.instacne.database;
    return await db.update('employees', employee.toMap(),
        where: 'id=?', whereArgs: [employee.id]);
  }

  Future<List<Employee>> getAllEmployees() async {
    Database db = await DBHelper.instacne.database;
    List<Map> maps = await db.query('employees');

    List<Employee> employees = [];

    for (int i = 0; i < maps.length; i++) {
      employees.add(Employee.fromMap(maps[i]));
    }

    return employees;
  }
}
