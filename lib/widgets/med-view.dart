import 'package:flutter/material.dart';
import '../models/medicine.dart';

class MedicineView extends StatefulWidget {
  final List<Medicine> meds;
  final Function(String) deleteMed;
  final Function(String) editMed;
  const MedicineView({Key? key, required this.meds, required this.deleteMed, required this.editMed,}) : super(key: key);

  @override
  State<MedicineView> createState() => _MedicineViewState();
}

class _MedicineViewState extends State<MedicineView> {
  final _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {

    if (widget.meds.isNotEmpty) {
      return ListView.builder(
        itemCount: widget.meds.length * 2,
        itemBuilder: ((context, i) {
          if (i.isOdd) return const Divider();

          final index = i ~/ 2;
          
            return ListTile(
              title: Text(
                widget.meds[index].name,
                style: _biggerFont,
              ),
              onTap: () => _pushMed(widget.meds[index]),
            );
        })
      );
    } else {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'You have no saved medications yet. Click below to add a new one.', 
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        )
      );
    }
  }

  void _pushMed(Medicine med) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('My Medications'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    "Name: ${med.name}.",
                    style: _biggerFont,
                  ),
                  Text(
                    "Dosage: ${med.dose}${med.unit == "Pill(s)" ? " ${med.unit}" : med.unit}.",
                    style: _biggerFont,
                  ),
                  Text(
                    "Times Per Day: ${med.reminders.length}.",
                    style: _biggerFont,
                  ),
                  Text(
                    "Term: ${ med.duration == 0 && !med.isActive ? "Long-term" : "Short-term" }.",
                    style: _biggerFont,
                  ),
                  if(med.duration != 0) Text(
                    "Duration: ${ med.duration } days.",
                    style: _biggerFont,
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => widget.deleteMed(med.id),
              backgroundColor: Colors.redAccent,
              child: Icon(Icons.delete),
            ),
          );
        },
      ),
    ).then((_) => setState(() {}));
  }
}