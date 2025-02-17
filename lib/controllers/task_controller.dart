import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

class TaskController extends GetxController {
  final List<Task> taskList = [
    Task(
      id: 3,
      isCompleted: 0,
      color: 2,
      note: 'note Something ',
      title: 'Note 1',
      startTime: DateFormat('hh:mm a')
          .format(DateTime.now().add(const Duration(minutes: 1)))
          .toString(),
      endTime: '6:00',
    ),
    Task(
      id: 2,
      isCompleted: 1,
      color: 1,
      note: 'note Something ',
      title: 'Note 2',
      startTime: DateFormat('hh:mm a')
          .format(DateTime.now().add(const Duration(minutes: 2)))
          .toString(),
      endTime: '6:00',
    ),
    Task(
      id: 22,
      isCompleted: 0,
      color: 2,
      note: 'note Something ',
      title: 'Note 3',
      startTime: DateFormat('hh:mm a')
          .format(DateTime.now().add(const Duration(minutes: 3)))
          .toString(),
      endTime: '6:00',
    ),
    Task(
      id: 221,
      isCompleted: 1,
      color: 0,
      note: 'note Something ',
      title: 'Note 4',
      startTime: DateFormat('hh:mm a')
          .format(DateTime.now().add(const Duration(minutes: 4)))
          .toString(),
      endTime: '6:00',
    ),
  ];

  getTasks() {}

  addTask({required Task task}) {}
}
