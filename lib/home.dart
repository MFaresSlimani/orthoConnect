import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:ortho_connect/screens/new_patient/new_patient.dart';
import 'package:ortho_connect/screens/new_vist_screen/new_visit_screen.dart';
import 'package:ortho_connect/screens/patient_details/patient_details.dart';
import 'package:ortho_connect/screens/patients_list/right_patients_list.dart';
import 'package:ortho_connect/screens/settings/settings.dart';
import 'package:ortho_connect/screens/welcome_screen/right_welcome_screen.dart';
import 'package:ortho_connect/widgets/left_side.dart';

import 'main.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WindowBorder(
        color: borderColor,
        width: 1,
        child: Row(
          children: [const LeftSide(), Obx(() => getRightScreen())],
        ),
      ),
    );
  }


  Widget getRightScreen() {
    String selectedOption = Get.find<RightContentController>().selectedOption.value;
    switch (selectedOption) {
      case 'Home':
        return const RightWelcomeScreen();
      case 'patientsList':
        return const RightPatientsList();
      case 'newPatient':
        return const RightNewPatientScreen();
      case 'newVisit':
        String selectedPatientCardId = Get.find<RightContentController>().selectedPatientId.value;
        return NewVisitScreen(cardID: selectedPatientCardId,);
      case 'Settings':
        return const Settings();
      case 'patientDetails':
        String selectedPatientCardId = Get.find<RightContentController>().selectedPatientId.value;
        return PatientDetails(cardID: selectedPatientCardId);
    // Add more cases as needed
      default:
        return Container();
    }
  }
}