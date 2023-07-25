import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/core/popups.dart';

import '../core/enums.dart';
import '../models/task/tasks_cubit.dart';
import '../models/task/tasks_states.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key, required this.status});

  final TaskStatus status;

  Future<bool> showConfirmDeleteDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Delete Task'),
              content:
                  const Text('Are you sure that you want to delete this task?'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white),
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('No'),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: BlocConsumer<TasksCubit, TasksState>(
        listenWhen: (prev, current) => current is TasksManagingStates,
        listener: (context, state) {
          if (state is TasksTaskManagedSuccessfullyState) {
            if (state.operationType == OperationType.add) {
              Popups.toast(
                  msg: 'Task added successfully', bgColor: Colors.green);
            } else if (state.operationType == OperationType.update) {
              Popups.toast(
                  msg: 'Task Updated successfully', bgColor: Colors.green);
            }
            if (state.operationType == OperationType.delete) {
              Popups.toast(
                  msg: 'Task deleted successfully', bgColor: Colors.green);
            }
          } else if (state is TasksTaskFailedToManageState) {
            Popups.toast(msg: state.failMsg);
          }
        },
        buildWhen: (prev, current) => current is TasksManagingStates,
        builder: (context, state) {
          final tasks = BlocProvider.of<TasksCubit>(context)
              .getTasksByStatus(status: status);

          print('Current Task Length: ${tasks.length}');
          return tasks.isEmpty
              ? Center(
                  child: Text(
                    'You don\'t have any tasks',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                )
              : ListView.separated(
                  itemBuilder: (context, index) {
                    return Dismissible(
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        // call delete method from tasks cubit
                        BlocProvider.of<TasksCubit>(context)
                            .deleteTask(task: tasks[index]);
                      },
                      confirmDismiss: (direction) async {
                        return await showConfirmDeleteDialog(context);
                      },
                      background: Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.delete,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                      key: ValueKey(tasks[index].id),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 32,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                              child: Text(
                                tasks[index].time,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        title: Text(tasks[index].title),
                        subtitle: Text(tasks[index].date),
                        trailing: status == TaskStatus.archivedTask
                            ? null
                            : IconButton(
                                icon: const Icon(Icons.check),
                                onPressed: () {
                                  if (tasks[index].status ==
                                      TaskStatus.newTask) {
                                    BlocProvider.of<TasksCubit>(context)
                                        .updateTaskStatus(
                                            id: tasks[index].id,
                                            status: TaskStatus.completedTask);
                                  } else {
                                    BlocProvider.of<TasksCubit>(context)
                                        .updateTaskStatus(
                                            id: tasks[index].id,
                                            status: TaskStatus.archivedTask);
                                  }
                                },
                              ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: tasks.length);
        },
      ),
    );
  }
}
