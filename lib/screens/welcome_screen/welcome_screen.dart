import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ortho_connect/helpers/database_helper.dart';
import 'package:path/path.dart' as path;
import 'package:ortho_connect/home.dart';
import 'package:sqflite/sqflite.dart';
import '../../main.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [backgroundStartColor, backgroundEndColor],
                stops: [0.0, 1.0]),
          ),
          alignment: Alignment.center,
          child: Column(
            children: [
              WindowTitleBarBox(
                child: Row(
                  children: [Expanded(child: MoveWindow()), const WindowButtons()],
                ),
              ),
              const SizedBox(height: 120),
              SizedBox(height: 260, child: Image.asset('assets/logo.png')),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  // Select a database file using file picker
                  FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['db']);
                  if (result != null) {
                    String filePath = result.files.single.path!;
                    // Open the selected database file
                    Database db = await openDatabase(filePath);
                    print('Opened Database: $filePath');
                    Get.showSnackbar(GetSnackBar(
                      message: 'Opened Database: $filePath',
                      duration: const Duration(seconds: 2),
                    ));
                    Get.to(() => const HomeScreen());
                  }
                },
                child: Text('Select a Database', style: GoogleFonts.abel()),
              ),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.abel(color: Colors.white, fontSize: 16),
                  children: <TextSpan>[
                    const TextSpan(text: 'You have no database? '),
                    TextSpan(
                      text: 'Create Database',
                      style: GoogleFonts.abel(color: Colors.blue, decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          // Open a directory picker dialog
                          String? directoryPath = await FilePicker.platform.getDirectoryPath();
                          if (directoryPath == null) {
                            print('User cancelled the picker');
                            return;
                          }

                          // Specify the database path
                          String dbPath = path.join(directoryPath, 'OrthoConnect_database.db');

                          // Initialize the database at the specified path
                          Database db = await openDatabase(
                            dbPath,
                            version: 1,
                            onCreate: (Database db, int version) async {
                              // Create the tables
                              await DatabaseHelper.instance.createDatabase(db, version);
                            },
                          );

                          // Check if the database file exists
                          File dbFile = File(dbPath);
                          bool doesExist = await dbFile.exists();

                          if (doesExist) {
                            Get.showSnackbar(GetSnackBar(
                              message: 'Database created at: $dbPath',
                              duration: const Duration(seconds: 2),
                            ));
                            print('Database created at: $dbPath');
                          } else {
                            print('Failed to create database at: $dbPath');
                          }

                          // Navigate to the HomeScreen
                          Get.to(() => const HomeScreen());
                        },
                    ),
                  ],
                ),
              ),
              // Add more components as needed
            ],
          ),
        ),
      ),
    );
  }
}