import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../classes/patient.dart';
import '../../main.dart';
import '../../helpers/database_helper.dart'; // Import the file where the DatabaseHelper class is defined

class RightNewPatientScreen extends StatelessWidget {
  const RightNewPatientScreen({Key? key}) : super(key: key);

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
        alignment: Alignment.center,
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
            Text(
              'New Patient',
              style: GoogleFonts.abel(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            // Form for updating patient details
            PatientForm(),

            // Add other components as needed
          ],
        ),
      ),
    );
  }
}

class PatientForm extends StatefulWidget {
  @override
  _PatientFormState createState() => _PatientFormState();
}

class _PatientFormState extends State<PatientForm> {
  String imagePath = 'assets/default_image.png';
  TextEditingController nameController = TextEditingController();
  TextEditingController cardIdController = TextEditingController();
  DateTime? birthdate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != birthdate) {
      setState(() {
        birthdate = picked;
      });
    }
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        imagePath = result.files.single.path!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Image update
          CircleAvatar(
            radius: 60,
            backgroundImage: FileImage(File(imagePath)),
          ),
          const SizedBox(
            height: 14,
          ),
          ElevatedButton(
            onPressed: () {_pickImage();},
            child: Text(
              'Update Picture',
              style:
              GoogleFonts.abel(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          // Name field
          TextFormField(
            controller: nameController,
            style: GoogleFonts.abel(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              label: Text('Name', style: GoogleFonts.abel(color: Colors.white)),
            ),
          ),
          // Card ID field
          TextFormField(
            controller: cardIdController,
            style: GoogleFonts.abel(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
                label: Text('Card ID',
                    style: GoogleFonts.abel(color: Colors.white))),
          ),
          // Birthdate field
          GestureDetector(
            onTap: () => _selectDate(context),
            child: AbsorbPointer(
                child: TextFormField(
                  readOnly: true,
                  controller:
                  //textediting controller with the selected date
                  TextEditingController(
                      text: birthdate == null
                          ? ''
                          : '${birthdate!.day}/${birthdate!.month}/${birthdate!.year}'),
                  style: GoogleFonts.abel(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    labelText: 'Birthdate',
                    labelStyle: GoogleFonts.abel(color: Colors.white),
                  ),
                )),
          ),
          const SizedBox(height: 60),
          // Save button
          ElevatedButton(
            onPressed: () async {
              // Create a new Patient object
              Patient newPatient = Patient(
                picture: imagePath,
                name: nameController.text,
                cardId: cardIdController.text,
                birthDate: birthdate!,
              );

              // Insert the new patient into the database
              int id = await DatabaseHelper.instance.insertPatient(newPatient);

              if (id != 0) {
                Get.find<RightContentController>()
                    .updateSelectedOption('patientsList');
                Get.showSnackbar(GetSnackBar(
                  messageText: Text(
                    'New patient saved!',
                    style: GoogleFonts.abel(color: Colors.white, fontSize: 16),
                  ),
                  backgroundGradient: const LinearGradient(
                      colors: [backgroundEndColor, backgroundStartColor]),
                  duration: const Duration(seconds: 2),
                ));
              } else {
                print('Failed to save the patient');
              }
            },
            child: Text(
              'Save New Patient',
              style:
              GoogleFonts.abel(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}