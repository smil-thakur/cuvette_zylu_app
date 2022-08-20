import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zylu/methods/employee.dart';
import 'package:zylu/methods/firestore_collect.dart';
import 'package:zylu/methods/work_duration.dart';
import 'package:zylu/widgets/key_maps.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isloading = true;
  List<Employee> employees = [];
  String x = "";
  collectData() async {
    isloading = true;
    setState(() {});
    employees = await collectEmployees();
    isloading = false;
    setState(() {});
  }

  double workDuration(String mydate, String endDate) {
    int year = int.parse(mydate[6] + mydate[7] + mydate[8] + mydate[9]);
    int month = int.parse(mydate[3] + mydate[4]);
    int date = int.parse(mydate[0] + mydate[1]);
    int diff = DurationMethods(endDate).getDifference(year, month, date);
    print(diff);
    return double.parse((diff / 365).toStringAsPrecision(2));
  }

  @override
  void initState() {
    super.initState();
    collectData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 228, 226),
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              collectData();
            },
            icon: const Icon(Icons.refresh),
          )
        ],
        title: Text(
          "Zylu Employees",
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const KeyMap(),
            isloading
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : SizedBox(
                    height: MediaQuery.of(context).size.height - 250,
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: employees.length,
                        itemBuilder: (BuildContext context, index) {
                          double durationWorked = workDuration(
                            employees[index].startDate,
                            employees[index].endDate == ""
                                ? DateTime.now().toString()
                                : employees[index]
                                    .endDate
                                    .split('/')
                                    .reversed
                                    .join('/')
                                    .toString(),
                          );
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const <BoxShadow>[
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 2,
                                    )
                                  ],
                                  color: Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: employees[index].active &&
                                                durationWorked >= 5
                                            ? Colors.green
                                            : Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      width: 50,
                                      height: 50,
                                      child: Center(
                                        child: Text(
                                          employees[index].name[0],
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Name: ${employees[index].name}",
                                          style:
                                              GoogleFonts.inter(fontSize: 15),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Gender: ${employees[index].gender}",
                                              style: GoogleFonts.inter(
                                                  fontSize: 15),
                                            ),
                                            Text(
                                              "Status: ${employees[index].active ? "Active" : "Not Active"}",
                                              style: GoogleFonts.inter(
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      "Joing Date: ${employees[index].startDate}",
                                      style: GoogleFonts.inter(fontSize: 15),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Left Date: ${employees[index].endDate == "" ? "currently working" : employees[index].endDate}",
                                      style: GoogleFonts.inter(fontSize: 15),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Center(
                                      child: Text(
                                        "Years Worked $durationWorked",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.inter(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
          ],
        ),
      ),
    );
  }
}
