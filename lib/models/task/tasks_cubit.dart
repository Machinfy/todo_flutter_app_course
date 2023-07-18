import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/models/task/task.dart';
import 'package:todo_app/models/task/tasks_states.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(TaskInitialState());

  var _tasks = <Task>[];

  List<Task> get tasks => [..._tasks];
}
