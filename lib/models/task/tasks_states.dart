import 'package:todo_app/core/enums.dart';

import 'task.dart';

abstract class TasksState {}

class TaskInitialState extends TasksState {}

// Fetching Tasks State

abstract class TasksFetchingStates extends TasksState {}

class TasksLoadedSuccessfullyState extends TasksFetchingStates {
  final List<Task> tasks;

  TasksLoadedSuccessfullyState({required this.tasks});
}

class TasksFailedToLoadedState extends TasksFetchingStates {
  final String failMsg;

  TasksFailedToLoadedState({required this.failMsg});
}

class TasksLoadingState extends TasksFetchingStates {}

// Managing Tasks State
abstract class TasksManagingStates extends TasksState {}

class TasksTaskManagedSuccessfullyState extends TasksManagingStates {
  final OperationType operationType;
  TasksTaskManagedSuccessfullyState({required this.operationType});
}

class TasksTaskFailedToManageState extends TasksManagingStates {
  final OperationType operationType;
  final String failMsg;
  TasksTaskFailedToManageState(
      {required this.operationType, required this.failMsg});
}
