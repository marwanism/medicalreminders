import 'package:flutter/material.dart';
import '../models/medicine.dart';

class ReminderView extends StatefulWidget {
  final List<Reminder> reminders;
  final int inView;
  const ReminderView({Key? key, required this.reminders, required this.inView,}) : super(key: key);

  @override
  State<ReminderView> createState() => _ReminderViewState();
}

class _ReminderViewState extends State<ReminderView> {

  final _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    if (widget.reminders.isNotEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: widget.reminders.length > widget.inView ? widget.inView : ( widget.reminders.isEmpty ? 0 : widget.reminders.length * 2),
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider();

          final index = i ~/ 2;
          // if (index >= widget.reminders.length) {
          //   widget.reminders.addAll(_getWords());
          // }

          return ListTile(
            title: Text(
              "${widget.reminders[index].dose.toString()}${widget.reminders[index].unit == "Pill(s)" ? " ${widget.reminders[index].unit}" : widget.reminders[index].unit} of ${widget.reminders[index].name} at ${widget.reminders[index].time.format(context)}.",
              // widget.reminders[index].dose.toString() + + widget.reminders[index].time.toString(),
              style: _biggerFont,
            ),
            // trailing: Icon(
            //   alreadySaved ? Icons.favorite : Icons.favorite_border,
            //   color: alreadySaved ? Colors.red : null,
            //   semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
            // ),
            // onTap: () {
            //   setState(() {
            //     if (alreadySaved) {
            //       _saved.remove(widget.reminders[index]);
            //     } else {
            //       _saved.add(widget.reminders[index]);
            //     }
            //   });
            // },
          );
        },
      );
    } else {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'No reminders yet. Add a medicine to view your reminders.', 
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
}