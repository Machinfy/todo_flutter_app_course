import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../screens/archived_tab.dart';
import '../screens/completed_tab.dart';
import '../screens/tasks_tab.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  var _isSheetOpened = false;
  var _currentTabIndex = 0;

  final _titleController = TextEditingController();
  final _dayDateController = TextEditingController();
  final _timeDateController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _tabs = const [
    TasksTab(),
    CompletedTab(),
    ArchivedTab(),
  ];

  final _appBarTitles = [
    'Current Tasks',
    'Completed Tasks',
    'Archived Tasks',
  ];

  void displayBottomSheet() {
    setState(() {
      _isSheetOpened = true;
    });
    _scaffoldKey.currentState!.showBottomSheet((_) => Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DefaultTextField(
                textController: _titleController,
                label: 'Title',
                hint: 'Do homework...',
                preIcon: Icons.title,
                onSubmitted: (value) {},
                onTap: () {},
              ),
              DefaultTextField(
                textController: _timeDateController,
                label: 'Time of the day',
                preIcon: Icons.timelapse,
                onSubmitted: (value) {},
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  // Show Time Picker
                  final timeOfDay = await displayTimePicker();
                  print(timeOfDay);
                  if (timeOfDay != null && mounted) {
                    _timeDateController.text = timeOfDay.format(context);
                  }
                },
              ),
              DefaultTextField(
                textController: _dayDateController,
                label: 'Date',
                preIcon: Icons.calendar_month,
                onSubmitted: (value) {},
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  // Show Date Picker
                  final date = await displayDatePicker();
                  print(date);
                  if (date != null) {
                    _dayDateController.text = DateFormat.yMMMd().format(date);
                  }
                },
              ),
            ],
          ),
        ));
  }

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

  void _closeBottomSheet() {
    Navigator.pop(context);
    _clearDataInputs();
    setState(() {
      _isSheetOpened = false;
    });
  }

  void _clearDataInputs() {
    _titleController.clear();
    _dayDateController.clear();
    _timeDateController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_appBarTitles[_currentTabIndex]),
      ),
      body: _tabs[_currentTabIndex],
      // body: Center(
      //   child: Column(
      //     children: [
      //       ElevatedButton(
      //         child: const Text('Press Me'),
      //         onPressed: () {
      //           print(_titleController.text);
      //         },
      //       ),
      //       ElevatedButton(
      //         child: const Text('Press Me2'),
      //         onPressed: () {
      //           _titleController.clear();
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_isSheetOpened) {
            _closeBottomSheet();
          } else {
            displayBottomSheet();
          }
        },
        child: Icon(_isSheetOpened ? Icons.add_task : Icons.edit),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (index) => setState(() => _currentTabIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Completed'),
          BottomNavigationBarItem(icon: Icon(Icons.archive), label: 'Archived'),
        ],
      ),
    );
  }
}

class DefaultTextField extends StatelessWidget {
  const DefaultTextField({
    super.key,
    required this.textController,
    required this.label,
    required this.preIcon,
    this.onTap,
    this.onSubmitted,
    this.hint,
  });

  final TextEditingController textController;
  //final void Function()? onTap;
  final VoidCallback? onTap;
  final void Function(String)? onSubmitted;
  final String label;
  final String? hint;
  final IconData preIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      onTap: onTap,
      autocorrect: false,
      onChanged: (value) {
        print('onChanged called: $value');
      },
      onSubmitted: onSubmitted,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          prefixIcon: Icon(preIcon), label: Text(label), hintText: hint),
    );
  }
}
