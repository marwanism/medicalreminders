import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import './new-med-form.dart';
import './reminder-view.dart';
import './med-view.dart';
import '../models/medicine.dart';

class MedsHome extends StatefulWidget {
  const MedsHome({super.key});

  @override
  State<MedsHome> createState() => _MedsHomeState();
}

class _MedsHomeState extends State<MedsHome> {
  final _suggestions = <String>[];
  final _saved = <String>{};
  final _biggerFont = const TextStyle(fontSize: 18);
  List<Medicine> meds = [];
  List<Reminder> reminders = [];
  int _generated = 0;

  saveMedicine(Medicine newMed) {
    setState(() {
      meds.add(newMed);
      List<Reminder> newReminders = newMed.reminders.map(( (rem) {
        return Reminder(name: newMed.name, dose: newMed.dose, unit: newMed.unit, medId: newMed.id, time: rem);
      })).toList();
      reminders.addAll(newReminders);
    });
  }

  deleteMedicine(String id) {
    setState(() {
      meds.removeWhere((item) => item.id == id);
      // Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.of(context).pop();
    });
  }

  editMedicine(String id) { //TODO: IMPLEMENT
    // setState(() {
    //   meds.removeWhere((item) => item.id == id);
    // });
  }

  @override
  Widget build(BuildContext context) {
    //final wordPair = WordPair.random();
    return Scaffold(   // NEW from here ...
      appBar: AppBar(  
        title: const Text('TakeYourMeds'),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black87,
              ),
              child: Text(
                'TakeYourMeds',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
              ),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                //TODO: fix home pop, make it pop all the way to home
              },
            ),
            ListTile(
              leading: Icon(
                Icons.animation, //TODO: change icon to pill
              ),
              title: const Text('Medications'),
              onTap: _pushMeds,
            ),
            ListTile(
              leading: Icon(
                Icons.account_circle,
              ),
              title: const Text('Profile'),
              onTap: _pushProfile,
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
              ),
              title: const Text('Settings'),
              onTap: _pushSettings,
            ),
          ],
        ),
      ),
      body: ReminderView(inView: 5, reminders: reminders,),
      floatingActionButton: FloatingActionButton(
        onPressed: _pushAddMed,
        backgroundColor: Colors.black87,
        child: Icon(Icons.add),
      ),
    );
  }

  void _pushMeds() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('My Medications'),
            ),
            body: MedicineView(meds: meds, deleteMed: deleteMedicine, editMed: editMedicine,),
            floatingActionButton: FloatingActionButton(
              onPressed: _pushAddMed,
              backgroundColor: Colors.black87,
              child: Icon(Icons.add),
            ),
          );
        },
      ),
    ).then((_) => setState(() {}));
  }

  void _pushSettings() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return ListTile(
                title: Text(
                  pair,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    ).then((_) => setState(() {}));
  }

  void _pushProfile() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return ListTile(
                title: Text(
                  pair,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    ).then((_) => setState(() {}));
  }

  void _pushAddMed() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Add A New Medicine'),
            ),
            body: NewMedForm(notifyParent: saveMedicine,),
          );
        },
      ),
    ).then((_) => setState(() {}));
  }

  List<String> _getWords() {
    return List<String>.filled(10, 'ZebbyManga').map((e) {
        _generated++;
        return e + _generated.toString();
      }
    ).toList();
  }
}