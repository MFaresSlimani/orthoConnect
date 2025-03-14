import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import '../classes/patient.dart';
import '../classes/visit.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    // If _database is null, initialize it
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String dbPath = path.join(await getDatabasesPath(), 'OrthoConnect_database.db');
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: createDatabase,
    );
  }

  Future<void> createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE patients (
        id INTEGER PRIMARY KEY,
        picture TEXT,
        name TEXT,
        cardId TEXT,
        birthDate TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE visits (
        id INTEGER PRIMARY KEY,
        cardId TEXT,
        visitDate TEXT,
        visitTime TEXT,
        illnessType TEXT,
        notes TEXT,
        FOREIGN KEY (cardId) REFERENCES patients (cardId) ON DELETE CASCADE
      )
    ''');
  }

  Future<int> insertPatient(Patient patient) async {
    Database db = await instance.database;
    return await db.insert(
      'patients',
      patient.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insertVisit(String patientCardId, Visit visit, BuildContext context) async {
    Database db = await instance.database;
    return await db.insert(
      'visits',
      visit.toMap(patientCardId),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Patient>> getAllPatients() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> patients = await db.query('patients');
    List<Patient> patientList = patients.map((patient) {
      return Patient.fromMap(patient);
    }).toList();
    return patientList;
  }

  Future<Patient> getPatient(String patientCardId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> patients = await db.query(
      'patients',
      where: 'cardId = ?',
      whereArgs: [patientCardId],
    );
    return Patient.fromMap(patients.first);
  }

  Future<List<Visit>> getVisitsForPatient(String cardId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> visits = await db.query(
      'visits',
      where: 'cardId = ?',
      whereArgs: [cardId],
    );
    List<Visit> visitList = visits.map((visit) {
      return Visit.fromMap(visit);
    }).toList();
    return visitList;
  }

  Future<void> saveDatabaseToExternalPath() async {
    // Get the current database path
    String dbPath = path.join(await getDatabasesPath(), 'OrthoConnect_database.db');

    // Read the database file into memory
    File dbFile = File(dbPath);
    List<int> dbBytes = await dbFile.readAsBytes();

    // Get the directory path from the user
    String? directoryPath = await FilePicker.platform.getDirectoryPath();
    String? savePath;
    if (directoryPath != null) {
      savePath = path.join(directoryPath, 'OrthoConnect_database.db');
    }

    if (savePath != null) {
      // Write the database file to the save path
      File outputFile = File(savePath);
      await outputFile.writeAsBytes(dbBytes);
    } else {
      print('User cancelled the picker');
    }
  }

  Future<void> resetDatabase() async {
    Database db = await instance.database;
    await db.close();

    // Delete the current database file
    String dbPath = await getDatabasesPath();
    await deleteDatabase(dbPath);

    // Reinitialize the database
    _database = await _initDatabase();
  }

  Future<void> importDatabase(String filePath) async {
    if (_database != null) {
      try {
        await _database!.close();
        print('Database closed');
      } on Exception catch (e) {
        print('Error closing the database: $e');
      }
    }
    // Read the database file into memory
    File dbFile = File(filePath);
    List<int> dbBytes = await dbFile.readAsBytes();

    // Get the current database path
    String dbPath = await getDatabasesPath();


    // Write the database file to the current database path
    File outputFile = File(dbPath);
    await outputFile.writeAsBytes(dbBytes);

    // Reinitialize the database
    _database = await _initDatabase();
  }




// Add other CRUD operations as needed
}