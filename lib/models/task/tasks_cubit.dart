import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/core/enums.dart';
import 'package:todo_app/core/sql_helper.dart';
import 'package:todo_app/models/task/task.dart';
import 'package:todo_app/models/task/tasks_states.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(TaskInitialState());

  var _tasks = <Task>[];

  List<Task> get tasks => [..._tasks];

  List<Task> getTasksByStatus({required TaskStatus status}) {
    return _tasks.where((task) => task.status == status).toList();
  }

  void getTasks() async {
    emit(TasksLoadingState());
    try {
      final rawData = await SqlHelper.getData(table: 'tasks');
      _tasks = rawData.map((taskJson) => Task.fromJson(taskJson)).toList();
      emit(TasksLoadedSuccessfullyState(tasks: tasks));
      print('Data retrieved successfully');
    } catch (error) {
      print(error.toString());
      emit(TasksFailedToLoadedState(failMsg: 'Something went wrong'));
    }
  }

  void addNewTask({required Task addedTask}) async {
    final rawData = addedTask.toJson();

    try {
      final idInDb = await SqlHelper.insert(table: 'tasks', data: rawData);
      _tasks.add(Task(
          id: idInDb.toString(),
          title: addedTask.title,
          date: addedTask.date,
          time: addedTask.time,
          status: addedTask.status));
      emit(TasksTaskManagedSuccessfullyState(operationType: OperationType.add));
    } catch (error) {
      emit(TasksTaskFailedToManageState(
          failMsg: 'Failed to add task', operationType: OperationType.add));
    }
  }

  void updateTaskStatus(
      {required String id, required TaskStatus status}) async {
    final task = _tasks.firstWhere((task) => task.id == id);
    final prevStatus = task.status;
    task.status = status;
    emit(
        TasksTaskManagedSuccessfullyState(operationType: OperationType.update));
    try {
      // await Future.delayed(const Duration(seconds: 4));
      // throw Exception();
      final numberOfRows = await SqlHelper.update(
          table: 'tasks',
          data: task.toJson(),
          columnValue: task.id,
          columnName: 'id');
      if (numberOfRows != 1) {
        throw Exception();
      }
    } catch (error) {
      task.status = prevStatus;
      emit(TasksTaskFailedToManageState(
          operationType: OperationType.update,
          failMsg: 'Can not be updated!!!'));
    }
  }

  void deleteTask({required Task task}) async {
    _tasks.remove(task);
    emit(
        TasksTaskManagedSuccessfullyState(operationType: OperationType.delete));
    try {
      // await Future.delayed(const Duration(seconds: 4));
      // throw Exception();
      await SqlHelper.delete(
          table: 'tasks', columnName: 'id', columnValue: task.id);
    } catch (error) {
      _tasks.add(task);
      emit(TasksTaskFailedToManageState(
          operationType: OperationType.delete, failMsg: 'Can not be deleted'));
    }
  }
}
