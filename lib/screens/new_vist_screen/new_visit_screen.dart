import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ortho_connect/classes/visit.dart';
import 'package:intl/intl.dart';
import '../../helpers/database_helper.dart';
import '../../main.dart';

class NewVisitScreen extends StatelessWidget {
  final String cardID;
  const NewVisitScreen({super.key, required this.cardID});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
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
          IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30,)),
          Text(
            'New Visit',
            style: GoogleFonts.abel(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          // Form for updating patient details
          Padding(
            padding: const EdgeInsets.all(20),
            child: VisitForm(cardID),
          ),
          // Add other components as needed
        ],
      ),
    ));
  }
}

class VisitForm extends StatefulWidget {
  final String cardID;
  const VisitForm(this.cardID, {super.key});


  @override
  _VisitFormState createState() => _VisitFormState();
}
class _VisitFormState extends State<VisitForm> {
  final _formKey = GlobalKey<FormState>();
  final _visitDateController = TextEditingController();
  final _visitTimeController = TextEditingController();
  final _illnessTypeController = TextEditingController();
  final _notesController = TextEditingController();


  @override
  void dispose() {
    _visitDateController.dispose();
    _visitTimeController.dispose();
    _illnessTypeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _visitDateController
                ..text = DateFormat('yyyy-MM-dd').format(DateTime.now()), // Set initial value to today's date
              readOnly: true, // Make the field read-only
              onTap: () async {
                // Show date picker when the field is tapped
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  setState(() {
                    _visitDateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Visit Date',
                hintText: 'Enter visit date',
                hintStyle: GoogleFonts.abel(color: Colors.white),
                labelStyle: GoogleFonts.abel(color: Colors.white),
              ),
              style: GoogleFonts.abel(color: Colors.white), // Set font style
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter visit date';
                }
                return null;
              },
            ),
          ),


          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _visitTimeController
                ..text = DateFormat('HH:mm').format(DateTime.now()), // Set initial value to current time
              readOnly: true, // Make the field read-only
              onTap: () async {
                // Show time picker when the field is tapped
                final selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (selectedTime != null) {
                  setState(() {
                    _visitTimeController.text = selectedTime.format(context);
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Visit Time',
                hintText: 'Enter visit time',
                hintStyle: GoogleFonts.abel(color: Colors.white),
                labelStyle: GoogleFonts.abel(color: Colors.white),
              ),
              style: GoogleFonts.abel(color: Colors.white), // Set font style
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter visit time';
                }
                return null;
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _illnessTypeController,
              decoration: InputDecoration(
                labelText: 'Illness Type',
                hintText: 'Enter illness type',
                hintStyle: GoogleFonts.abel(color: Colors.white),
                labelStyle: GoogleFonts.abel(color: Colors.white),
              ),
              style: GoogleFonts.abel(color: Colors.white), // Set font style
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter illness type';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: 'Notes',
                hintText: 'Enter notes',
                hintStyle: GoogleFonts.abel(color: Colors.white),
                labelStyle: GoogleFonts.abel(color: Colors.white),
              ),
              style: GoogleFonts.abel(color: Colors.white), // Set font style
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter notes';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Visit newVisit = Visit(
                    visitDate: _visitDateController.text,
                    visitTime: _visitTimeController.text,
                    illnessType: _illnessTypeController.text,
                    notes: _notesController.text,
                    cardId: widget.cardID,
                  );
                  // Insert the new visit into the database
                  DatabaseHelper.instance.insertVisit(widget.cardID, newVisit, context);
                  // Show a snackbar
                  Get.snackbar('Success', 'Visit added successfully'
                  );
                  //navigate to the patient details screen
                  Get.find<RightContentController>().updateSelectedOption('patientDetails', patientId: widget.cardID);
                }
              },
              child: Text('Add Visit', style: GoogleFonts.abel(),),
            ),
          ),
        ],
      ),
    );
  }
}
