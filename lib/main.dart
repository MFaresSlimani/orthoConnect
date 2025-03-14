import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:get/get.dart';
import 'package:ortho_connect/screens/welcome_screen/welcome_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
//import path
import 'package:path/path.dart' as path;

import 'home.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(MyApp());
  doWhenWindowReady(() async {
    final win = appWindow;
    const initialSize = Size(800, 650);
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = "Ortho Connect";
    win.show();

    // Check if a database exists in the path "P"
    String dbPath = path.join(await getDatabasesPath(), 'OrthoConnect_database.db');
    File dbFile = File(dbPath);
    bool doesExist = await dbFile.exists();

    print('Database exists: $doesExist');
    print('Database path: $dbPath');

    if (doesExist) {
      // If a database exists, navigate to the HomeScreen
      Get.to(() => const HomeScreen());
    } else {
      // If a database does not exist, navigate to the WelcomeScreen
      Get.to(() => const WelcomeScreen());
    }
  });
}

class LeftSideController extends GetxController {
  RxDouble containerHeight = 600.0.obs;

  void updateContainerHeight(double newHeight) {
    containerHeight.value = newHeight;
  }
}

class RightContentController extends GetxController {
  RxString selectedOption = 'Home'.obs;
  RxString selectedPatientId = ''.obs;

  void updateSelectedPatient(String patientId) {
    selectedPatientId.value = patientId;
  }

  void updateSelectedOption(String newOption, {patientId}) {
    selectedOption.value = newOption;
  }

  void navigateToNewPatientScreen() {
    updateSelectedOption('newPatient');
  }

  void navigateToNewVisitScreen() {
    updateSelectedOption('newVisit');
  }
}

const borderColor = Color(0xFF805306);

class MyApp extends StatelessWidget {
  final LeftSideController leftSideController = Get.put(LeftSideController());
  final RightContentController rightContentController = Get.put(RightContentController());

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }

}

const sidebarColor = Color(0xFF2B035E);
const backgroundEndColor= Color(0xFF1A0240); // Darker shade
const backgroundStartColor = Color(0xFF4D0581); // Lighter shade

final buttonColors = WindowButtonColors(
    iconNormal: const Color(0xFF805306),
    mouseOver: const Color(0xFFF6A00C),
    mouseDown: const Color(0xFF805306),
    iconMouseOver: const Color(0xFF805306),
    iconMouseDown: const Color(0xFFFFD500));

final closeButtonColors = WindowButtonColors(
    mouseOver: const Color(0xFFD32F2F),
    mouseDown: const Color(0xFFB71C1C),
    iconNormal: const Color(0xFF805306),
    iconMouseOver: Colors.white);

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}

