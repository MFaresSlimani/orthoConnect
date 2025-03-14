import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ortho_connect/classes/patient.dart';
import 'package:ortho_connect/helpers/database_helper.dart';

import '../../classes/visit.dart';
import '../../main.dart';

class PatientDetails extends StatefulWidget {
  final String cardID;

  const PatientDetails({Key? key, required this.cardID}) : super(key: key);

  @override
  _PatientDetailsState createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails> {
  late Future<Patient> _patientFuture;

  @override
  void initState() {
    super.initState();
    _patientFuture = DatabaseHelper.instance.getPatient(widget.cardID);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [backgroundStartColor, backgroundEndColor],
            stops: [0.0, 1.0],
          ),
        ),
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            WindowTitleBarBox(
              child: Row(
                children: [
                  Expanded(child: MoveWindow()),
                  const WindowButtons()
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: IconButton(
                    onPressed: () {
                      Get.find<RightContentController>()
                          .updateSelectedOption('patientsList');
                    },
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 20),
                  ),
                ),
                Text(
                  'Patient Details',
                  style: GoogleFonts.abel(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: IconButton(
                    tooltip: 'Add a visit',
                    style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                    onPressed: () {
                      Get.find<RightContentController>()
                          .navigateToNewVisitScreen();
                    },
                    icon: const Icon(Icons.add),
                    color: Colors.white,
                    iconSize: 28,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            FutureBuilder<Patient>(
              future: _patientFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  Patient patient = snapshot.data!;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: ListView(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: FileImage(File(patient.picture)),
                          ),
                          const SizedBox(height: 60),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Name: ',
                                      style: GoogleFonts.abel(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 10),
                                  Text('Card ID: ',
                                      style: GoogleFonts.abel(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 10),
                                  Text('Birth Date: ',
                                      style: GoogleFonts.abel(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(
                                  width: 20), // Add spacing between columns
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(patient.name,
                                      style: GoogleFonts.abel(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal)),
                                  const SizedBox(height: 10),
                                  Text(patient.cardId.toString(),
                                      style: GoogleFonts.abel(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal)),
                                  const SizedBox(height: 10),
                                  Text(
                                    '${patient.birthDate.day}/${patient.birthDate.month}/${patient.birthDate.year}',
                                    style: GoogleFonts.abel(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          VisitsList(patient: patient),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class VisitsList extends StatefulWidget {
  final Patient patient;

  const VisitsList({Key? key, required this.patient}) : super(key: key);

  @override
  _VisitsListState createState() => _VisitsListState();
}

class _VisitsListState extends State<VisitsList> {
  late Future<List<Visit>> _visitsFuture;

  @override
  void initState() {
    super.initState();
    _visitsFuture =
        DatabaseHelper.instance.getVisitsForPatient(widget.patient.cardId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Visit>>(
      future: _visitsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return Center(
              child: Text('Error: ${snapshot.error}',
                  style: GoogleFonts.abel(color: Colors.white)));
        } else {
          List<Visit> visits = snapshot.data!;
          return visits.isEmpty
              ? const Center(
                  child: Text(
                    'No visits found',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                )
              : Center(
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    // allow horizontal scrolling

                    physics: const BouncingScrollPhysics(),
                    child: DataTable(columns: [
                      DataColumn(
                          label: Text('Date',
                              style: GoogleFonts.abel(color: Colors.white))),
                      DataColumn(
                          label: Text('Time',
                              style: GoogleFonts.abel(color: Colors.white))),
                      DataColumn(
                          label: Text('Illness Type',
                              style: GoogleFonts.abel(color: Colors.white))),
                      DataColumn(
                          label: Text('Notes',
                              style: GoogleFonts.abel(color: Colors.white))),
                    ], rows: [
                      for (Visit visit in visits)
                        DataRow(cells: [
                          DataCell(Text(visit.visitDate,
                              style: GoogleFonts.abel(color: Colors.white))),
                          DataCell(Text(visit.visitTime,
                              style: GoogleFonts.abel(color: Colors.white))),
                          DataCell(Text(visit.illnessType,
                              style: GoogleFonts.abel(color: Colors.white))),
                          DataCell(Text(visit.notes,
                              style: GoogleFonts.abel(color: Colors.white))),
                        ]),
                    ]),
                  ),
              );
        }
      },
    );
  }
}
