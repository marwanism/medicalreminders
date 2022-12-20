import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './time-reminder-input.dart';
import '../models/medicine.dart';

class NewMedForm extends StatefulWidget {
  final Function(Medicine) notifyParent;
  const NewMedForm({Key? key, required this.notifyParent}) : super(key: key);

  @override
  NewMedFormState createState() {
    return NewMedFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class NewMedFormState extends State<NewMedForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<NewMedFormState>.
  final _formKey = GlobalKey<FormState>();
  int timesValue = 0;
  final _timesItems = [0, 1, 2, 3, 4, 5, 6, 7, 8];
  String doseUnitValue = "Pill(s)";
  final _doseUnitItems = ["Pill(s)", "mg", "ml"];
  String termValue = "Long-term";
  final _termItems = ["Long-term", "Short-term"];
  List<Widget> _reminderInputs = [];
  List<Widget> activeReminderInputs = [];

  String name = "";
  double dose = 0;
  int duration = 0;
  List<TimeOfDay> reminders = [];

  addReminder(TimeOfDay rem) {
    setState(() {
      reminders.add(rem);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    _reminderInputs = List<Widget>.filled(8, TimeReminderInput(notifyParent: addReminder));
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Name",
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "Dosage",
                          ),
                          onChanged: (value) {
                            setState(() {
                              dose = double.tryParse(value)!;
                            });
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter dosage';
                            } else if(double.tryParse(value) == null) {
                              return "Please enter a valid dosage";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    DropdownButton(
                      // Initial Value
                      value: doseUnitValue,
                      
                      // Down Arrow Icon
                      icon: const Icon(Icons.keyboard_arrow_down),   
                      
                      // Array list of items
                      items: _doseUnitItems.map((String item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(() {
                          doseUnitValue = newValue!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text('Times Per Day'),
                    DropdownButton(
                      // Initial Value
                      value: timesValue,
                      
                      // Down Arrow Icon
                      icon: const Icon(Icons.keyboard_arrow_down),   
                      
                      // Array list of items
                      items: _timesItems.map((int item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item.toString()),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (value) {
                        setState(() {
                          timesValue = value!;
                          activeReminderInputs = _reminderInputs.sublist(0,timesValue);
                        });
                      },
                    ),
                  ],
                ),
              ),
              if(timesValue > 0) Padding(
                padding: EdgeInsets.symmetric(vertical: activeReminderInputs.isNotEmpty ? 8.0 : 0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: activeReminderInputs,
                ),
              ),
              // TimeReminderInput(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text('Long-term / Short-term'),
                    DropdownButton(
                      // Initial Value
                      value: termValue,
                      
                      // Down Arrow Icon
                      icon: const Icon(Icons.keyboard_arrow_down),   
                      
                      // Array list of items
                      items: _termItems.map((String item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (value) {
                        setState(() {
                          termValue = value!;
                          if (termValue == "Long-term") {
                            //Hide duration
                          } else {
                            //show duration
                          }
                          // activeReminderInputs = _reminderInputs.sublist(0,timesValue);
                        });
                      },
                    ),
                  ],
                ),
              ),
              if(termValue == "Short-term") Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Duration",
                          ),
                          onChanged: (value) {
                            setState(() {
                              duration = int.tryParse(value)!;
                            });
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter duration';
                            } else if(int.tryParse(value) == null) {
                              return "Please enter a valid duration";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const Text('Days'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                      print(name + "  " + dose.toString() + " " + doseUnitValue);
                      print(reminders);

                      Medicine newMed = Medicine(
                        id: DateTime.now().millisecondsSinceEpoch.toString() ,
                        name: name ,
                        dose: dose ,
                        unit: doseUnitValue ,
                        reminders: reminders ,
                        duration: duration,
                      );

                      print(newMed);

                      widget.notifyParent(newMed);

                      Navigator.of(context).pop();
                      // Navigator.of(context).popUntil((route) => route.isFirst);
                    }
                  },
                  child: const Text('Add'),
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}