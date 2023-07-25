import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/core/enums.dart';
import 'package:todo_app/models/task/task.dart';
import 'package:todo_app/models/task/tasks_cubit.dart';
import 'package:todo_app/models/task/tasks_states.dart';
import 'package:todo_app/widgets/new_task_form.dart';

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
  final _tabs = [
    TasksTab(),
    CompletedTab(),
    ArchivedTab(),
  ];

  final _appBarTitles = [
    'Current Tasks',
    'Completed Tasks',
    'Archived Tasks',
  ];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TasksCubit>(context).getTasks();
  }

  bool validateForm() {
    if (_titleController.text.isEmpty ||
        _timeDateController.text.isEmpty ||
        _dayDateController.text.isEmpty) {
      return false;
    }
    return true;
  }

  void addNewTask() {
    if (validateForm()) {
      final addedTask = Task(
          title: _titleController.text,
          id: DateTime.now().toString(),
          date: _dayDateController.text,
          time: _timeDateController.text,
          status: TaskStatus.newTask);
      BlocProvider.of<TasksCubit>(context).addNewTask(addedTask: addedTask);
      _closeBottomSheet();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please complete missing data'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void displayBottomSheet() {
    setState(() {
      _isSheetOpened = true;
    });
    _scaffoldKey.currentState!.showBottomSheet((_) => NewTaskForm(
          dateController: _dayDateController,
          timeOfDayController: _timeDateController,
          titleController: _titleController,
        ));
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
      body: BlocBuilder<TasksCubit, TasksState>(
        buildWhen: (prev, current) => current is TasksFetchingStates,
        builder: (context, state) {
          if (state is TasksLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is TasksFailedToLoadedState) {
            return Center(
              child: Text(
                'Something went wrong!!!',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            );
          }
          return _tabs[_currentTabIndex];
        },
      ),
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
            addNewTask();
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
