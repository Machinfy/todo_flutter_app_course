import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TasksTab extends StatelessWidget {
  const TasksTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 32,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FittedBox(
                          child: Text(
                            TimeOfDay.now().format(context),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    title: const Text('Task Title'),
                    subtitle: Text(DateFormat.yMMMEd().format(DateTime.now())),
                    trailing: Icon(Icons.check),
                  );
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: 10),
          ),
        ),
      ],
    );
  }
}
