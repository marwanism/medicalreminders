import 'package:flutter/material.dart';
import 'package:medicalremcs/helper/constants.dart';

class Medicine {
  String id = '0'; //unix timestamp
  String name = '';
  double dose = 0.0;
  String unit = "Pill(s)"; //, "mg", "ml"
  int duration = 0; //in days
  List<TimeOfDay> reminders = [];
  bool isActive = true;

  static List<Medicine> allMeds = [];

  Medicine({
    required this.id,
    this.name = '',
    this.dose = 0,
    this.unit = 'ml',
    this.duration = 0,
    this.reminders = const [],
  });

  toJson() {
    return {
      colMedName: name,
      colMedDose: dose,
      colMedUnit: unit,
      colMedDuration: duration,
      colMedIsActive: isActive,
    };
  }

  remsToJson() {
    return reminders.map( (e) {
      return {
        colRemHours: e.hour,
        colRemMinutes: e.minute,
        colRemMedicineId: id,
      };
    }).toList();
  }

  Medicine.fromJson(Map<dynamic, dynamic> map) {
    id = map[colId];
    name = map[colMedName];
    unit = map[colMedUnit];
    dose = map[colMedDose];
    duration = map[colMedDuration];
    isActive = map[colMedIsActive];
  }

  // static List<Medicine> medList() {
  //   return [
  //     ToDo(id: '01', todoText: 'Morning Excercise', isDone: true ),
  //     ToDo(id: '02', todoText: 'Buy Groceries', isDone: true ),
  //     ToDo(id: '03', todoText: 'Check Emails', ),
  //     ToDo(id: '04', todoText: 'Team Meeting', ),
  //     ToDo(id: '05', todoText: 'Work on mobile apps for 2 hour', ),
  //     ToDo(id: '06', todoText: 'Dinner with Jenny', ),
  //   ];
  // }
}

class Reminder {
  String name;
  double dose;
  String unit;
  TimeOfDay time;
  String medId;

  Reminder({
    required this.name,
    required this.dose,
    required this.unit,
    required this.time,
    required this.medId,
  });
}