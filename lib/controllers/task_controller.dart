import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tasky/db/db_helper.dart';
import '../models/task.dart';

class TaskController extends GetxController {
  final RxList<Task> taskList = <Task>[].obs;

  getTasks() async {
    final List<Map<String, dynamic>> tasks = await DbHelper.query();
    taskList
        .assignAll(tasks.map((taskData) => Task.fromMap(taskData)).toList());
  }

  Future<int> addTask({required Task task}) {
    return DbHelper.insert(task);
  }

  deleteTask({required Task task}) async {
    await DbHelper.delete(task);
    getTasks();
  }

  setTaskAsCompleted({required int taskId}) async {
    await DbHelper.update(taskId);
    getTasks();
  }
}
//  Task(
//       id: 3,
//       isCompleted: 0,
//       color: 2,
//       note: 'note Something ',
//       title: 'Note 1',
//       startTime: DateFormat('hh:mm a')
//           .format(DateTime.now().add(const Duration(minutes: 1)))
//           .toString(),
//       endTime: '6:00',
//     ),
//     Task(
//       id: 2,
//       isCompleted: 1,
//       color: 1,
//       note: 'note Something ',
//       title: 'Note 2',
//       startTime: DateFormat('hh:mm a')
//           .format(DateTime.now().add(const Duration(minutes: 2)))
//           .toString(),
//       endTime: '6:00',
//     ),
//     Task(
//       id: 22,
//       isCompleted: 0,
//       color: 2,
//       note: 'note Something ',
//       title: 'Note 3',
//       startTime: DateFormat('hh:mm a')
//           .format(DateTime.now().add(const Duration(minutes: 3)))
//           .toString(),
//       endTime: '6:00',
//     ),
//     Task(
//       id: 221,
//       isCompleted: 1,
//       color: 0,
//       note: 'note Something ',
//       title: 'Note 4',
//       startTime: DateFormat('hh:mm a')
//           .format(DateTime.now().add(const Duration(minutes: 4)))
//           .toString(),
//       endTime: '6:00',
//     ),