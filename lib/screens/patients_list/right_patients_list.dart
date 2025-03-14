import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../classes/patient.dart';
import '../../helpers/database_helper.dart';
import '../../main.dart';
import '../new_patient/new_patient.dart';

class RightPatientsList extends StatefulWidget {
  const RightPatientsList({Key? key}) : super(key: key);

  @override
  _RightPatientsListState createState() => _RightPatientsListState();
}

class _RightPatientsListState extends State<RightPatientsList> {
  TextEditingController searchController = TextEditingController();
  List<Patient> allPatients = [];
  List<Patient> displayedPatients = [];

  @override
  void initState() {
    super.initState();
    fetchPatients();
  }

  fetchPatients() async {
    allPatients = await DatabaseHelper.instance.getAllPatients();
    setState(() {
      displayedPatients = List.from(allPatients);
    });
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
              stops: [0.0, 1.0]),
        ),
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
                const SizedBox(),
                Text(
                  'Patients List',
                  style: GoogleFonts.abel(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: IconButton(
                    tooltip: 'Add a new patient',
                    style: ButtonStyle(
                      overlayColor:
                      MaterialStateProperty.all(Colors.transparent),
                    ),
                    onPressed: () {
                      Get.find<RightContentController>()
                          .navigateToNewPatientScreen();
                    },
                    icon: const Icon(Icons.add),
                    color: Colors.white,
                    iconSize: 28,
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            buildSearchBox(),
            const SizedBox(height: 10),
            Expanded(
              child: buildPatientsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        style: GoogleFonts.abel(color: Colors.black, fontSize: 20),
        controller: searchController,
        onChanged: (value) {
          setState(() {
            displayedPatients = filterPatients(value);
          });
        },
        decoration: InputDecoration(
          hintText: 'Search by name or patient number',
          hintStyle: GoogleFonts.abel(color: Colors.grey),
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  List<Patient> filterPatients(String query) {
    if (query.isEmpty) {
      return List.from(allPatients);
    }

    return allPatients
        .where((patient) => patient.name.toLowerCase().contains(query.toLowerCase()) || patient.cardId.toString().contains(query.toLowerCase()))
        .toList();
  }

  Widget buildPatientsList() {
    return FutureBuilder<List<Patient>>(
      future: DatabaseHelper.instance.getAllPatients(),
      builder: (BuildContext context, AsyncSnapshot<List<Patient>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          allPatients = snapshot.data!;
          displayedPatients = filterPatients(searchController.text);
          if (displayedPatients.isEmpty) {
            return Center(
              child: Text(
                'No patients found',
                style: GoogleFonts.abel(color: Colors.white),
              ),
            );
          }
          return ListView.builder(
            itemCount: displayedPatients.length,
            itemBuilder: (context, index) {
              return buildPatientCard(displayedPatients[index]);
            },
          );
        }
      },
    );
  }

  Widget buildPatientCard(Patient patient) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 3,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          title: Text(patient.name, style: GoogleFonts.abel()),
          subtitle: Text(
            'Card ID: ${patient.cardId}',
            style: GoogleFonts.abel(),
          ),
          onTap: () {
            Get.find<RightContentController>().updateSelectedOption('patientDetails');
            Get.find<RightContentController>().updateSelectedPatient(patient.cardId);
          },
        ),
      ),
    );
  }
}