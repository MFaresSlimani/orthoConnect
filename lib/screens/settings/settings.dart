import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ortho_connect/helpers/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import '../../home.dart';
import '../../main.dart';
import 'package:path/path.dart' as path;

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {


  @override
  void initState() {
    super.initState();
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(),
                Text(
                  'Settings',
                  style: GoogleFonts.abel(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text(
                      'Export Database',
                      style: GoogleFonts.abel(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      try {
                        // Export the database
                        DatabaseHelper.instance.saveDatabaseToExternalPath();
                        Get.showSnackbar(GetSnackBar(
                          messageText: Text(
                            'Database exported!',
                            style: GoogleFonts.abel(
                                color: Colors.white, fontSize: 16),
                          ),
                          backgroundGradient: const LinearGradient(
                              colors: [backgroundEndColor, backgroundStartColor]),
                          duration: const Duration(seconds: 2),
                        ));
                      } catch (e) {
                        Get.showSnackbar(GetSnackBar(
                          messageText: Text(
                            'Error exporting database!',
                            style: GoogleFonts.abel(
                                color: Colors.white, fontSize: 16),
                          ),
                          backgroundGradient: const LinearGradient(
                              colors: [backgroundEndColor, backgroundStartColor]),
                          duration: const Duration(seconds: 2),
                        ));
                      }
                    },
                  ),
                  ListTile(
                    title: Text('Create Database',
                      style: GoogleFonts.abel(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () async {
                      bool shouldSave = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Save current database?'),
                            content: Text('Do you want to save the current database before creating a new one?'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('No'),
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                              ),
                              TextButton(
                                child: Text('Yes'),
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                              ),
                            ],
                          );
                        },
                      ) ?? false;

                      if (shouldSave) {
                        await DatabaseHelper.instance.saveDatabaseToExternalPath();
                      }

                      await DatabaseHelper.instance.resetDatabase();

                      // await something
                    },
                  ),
                  ListTile(
                    title: Text('Import Database',
                      style: GoogleFonts.abel(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () async {
                      bool shouldSave = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Save current database?'),
                            content: Text('Do you want to save the current database before creating a new one?'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('No'),
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                              ),
                              TextButton(
                                child: Text('Yes'),
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                              ),
                            ],
                          );
                        },
                      ) ?? false;

                      if (shouldSave) {
                        await DatabaseHelper.instance.saveDatabaseToExternalPath();
                      }

                      // Open a file picker dialog
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['db'],
                      );
                      if (result != null) {
                        String filePath = result.files.single.path!;


                        try {
                          await DatabaseHelper.instance.importDatabase(filePath);
                          print('Database imported!');
                        } on Exception catch (e) {
                          print('Error importing database: $e');
                        }
                        Get.showSnackbar(GetSnackBar(
                          messageText: Text(
                            'Opened Database: $filePath',
                            style: GoogleFonts.abel(
                                color: Colors.white, fontSize: 16),
                          ),
                          backgroundGradient: const LinearGradient(
                              colors: [backgroundEndColor, backgroundStartColor]),
                          duration: const Duration(seconds: 2),
                        ));
                        // get off all screens and go to home
                        Get.offAll(() => const HomeScreen());
                      }
                    },
                  ),
                  ListTile(
                    title: Text('import'),
                        onTap: () async {
                      // Open a file picker dialog
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['db'],
                      );
                      if (result != null) {
                        String filePath = result.files.single.path!;

                        try {
                          await DatabaseHelper.instance.importDatabase(filePath);
                          print('Database imported!');
                        } on Exception catch (e) {
                          print('Error importing database: $e');
                        }
                        Get.showSnackbar(GetSnackBar(
                          messageText: Text(
                            'Opened Database: $filePath',
                            style: GoogleFonts.abel(
                                color: Colors.white, fontSize: 16),
                          ),
                          backgroundGradient: const LinearGradient(
                              colors: [backgroundEndColor, backgroundStartColor]),
                          duration: const Duration(seconds: 2),
                        ));
                        // get off all screens and go to home
                        Get.offAll(() => const HomeScreen());
                      }
    }
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
