import 'package:todo_app/core/enums.dart';

import 'task.dart';

abstract class TasksState {}

class TaskInitialState extends TasksState {}

// Fetching Tasks State
class TasksLoadedSuccessfullyState extends TasksState {
  final List<Task> tasks;

  TasksLoadedSuccessfullyState({required this.tasks});
}

class TasksFailedToLoadedState extends TasksState {
  final String failMsg;

  TasksFailedToLoadedState({required this.failMsg});
}

class TasksLoadingState extends TasksState {}

// Managing Tasks State
class TasksTaskManagedSuccessfullyState extends TasksState {
  final OperationType operationType;
  TasksTaskManagedSuccessfullyState({required this.operationType});
}

class TasksTaskFailedToManageState extends TasksState {
  final OperationType operationType;
  final String failMsg;
  TasksTaskFailedToManageState(
      {required this.operationType, required this.failMsg});
}
