import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zylu/methods/employee.dart';
import 'package:zylu/methods/work_duration.dart';

CollectionReference employeesCollection =
    FirebaseFirestore.instance.collection('employees');
Future<List<Employee>> collectEmployees() async {
  List<Employee> employees = [];

  try {
    await employeesCollection.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Employee tempemp = Employee(doc['startDate'], doc['name'],
            doc['endDate'], doc['age'], doc['active'], doc['gender']);
        employees.add(tempemp);
      });
    });
  } catch (e) {
    print(e);
  }
  print(employees.length);
  employees.forEach((element) {
    print(element.active);
  });
  return employees;
}

AddEmployeeFirebase(Employee employee, BuildContext context) async {
  try {
    await employeesCollection.add({
      'active': employee.active,
      'age': employee.age,
      'endDate': employee.endDate,
      'gender': employee.gender,
      'name': employee.name,
      'startDate': employee.startDate,
    });
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Employee Added refresh to see changes")));
  } catch (e) {
    print(e);
  }
}
