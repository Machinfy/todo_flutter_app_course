import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'default_text_field.dart';

class NewTaskForm extends StatefulWidget {
  const NewTaskForm(
      {super.key,
      required this.dateController,
      required this.timeOfDayController,
      required this.titleController});

  final TextEditingController titleController;
  final TextEditingController timeOfDayController;
  final TextEditingController dateController;
  @override
  State<NewTaskForm> createState() => _NewTaskFormState();
}

class _NewTaskFormState extends State<NewTaskForm> {
  Future<TimeOfDay?> displayTimePicker() async {
    final timeDay =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    return timeDay;
  }

  Future<DateTime?> displayDatePicker() async {
    return await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DefaultTextField(
            textController: widget.titleController,
            label: 'Title',
            hint: 'Do homework...',
            preIcon: Icons.title,
          ),
          DefaultTextField(
            textController: widget.timeOfDayController,
            label: 'Time of the day',
            preIcon: Icons.timelapse,
            onSubmitted: (value) {},
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              // Show Time Picker
              final timeOfDay = await displayTimePicker();
              print(timeOfDay);
              if (timeOfDay != null && mounted) {
                widget.timeOfDayController.text = timeOfDay.format(context);
              }
            },
          ),
          DefaultTextField(
            textController: widget.dateController,
            label: 'Date',
            preIcon: Icons.calendar_month,
            onSubmitted: (value) {},
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              // Show Date Picker
              final date = await displayDatePicker();
              print(date);
              if (date != null) {
                widget.dateController.text = DateFormat.yMMMd().format(date);
              }
            },
          ),
        ],
      ),
    );
  }
}
