import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeReminderInput extends StatefulWidget {
  // final GlobalKey enclosingForm;
  final Function(TimeOfDay) notifyParent;

  const TimeReminderInput({ Key? key, required this.notifyParent}): super(key: key);

  @override
  State<TimeReminderInput> createState() => _TimeReminderInputState();
}

class _TimeReminderInputState extends State<TimeReminderInput> {

  TextEditingController timeinput = TextEditingController();

  @override
  void initState() {
    timeinput.text = "00:00:00"; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                  controller: timeinput, //editing controller of this TextField
                  decoration: InputDecoration( 
                      icon: Icon(Icons.timer), //icon of text field
                  ),
                  readOnly: true,  //set it true, so that user will not able to edit text
                  onTap: () async {
                    TimeOfDay? pickedTime =  await showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                        );
                    
                    print(pickedTime);

                    if(pickedTime != null ){
                        print(pickedTime.format(context));   //output 10:51 PM
                        DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                        //converting to DateTime so that we can further format on different pattern.
                        print(parsedTime); //output 1970-01-01 22:53:00.000
                        String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
                        print(formattedTime); //output 14:59:00
                        //DateFormat() is from intl package, you can format the time on any pattern you need.

                        timeinput.text = formattedTime;

                        widget.notifyParent(pickedTime);
                    }else{
                        print("Time is not selected");
                    }
                  },
                ),
              );
  }
}