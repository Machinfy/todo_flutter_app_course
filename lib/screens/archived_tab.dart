import 'package:flutter/material.dart';

import '../core/enums.dart';
import '../widgets/tasks_list.dart';

class ArchivedTab extends StatelessWidget {
  const ArchivedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const TaskList(status: TaskStatus.archivedTask);
  }
}
