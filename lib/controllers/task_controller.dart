import 'package:get/get.dart';
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
    var intReturned = DbHelper.insert(task);
    // Get.snackbar('Task Added', '',
    //     snackPosition: SnackPosition.BOTTOM,
    //     backgroundColor: Colors.white,
    //     colorText: primaryClr,
    //     icon: const Icon(
    //       Icons.add,
    //       size: 25,
    //       color: primaryClr,
    //     ));
    return intReturned;
  }

  deleteTask({required Task task}) async {
    await DbHelper.delete(task);
    // Get.snackbar('Task Deleted', 'You Deleted a Task',
    //     snackPosition: SnackPosition.BOTTOM,
    //     backgroundColor: Colors.white,
    //     colorText: Colors.pink,
    //     icon: const Icon(
    //       Icons.delete,
    //       size: 25,
    //       color: Colors.red,
    //     ));
    getTasks();
  }

  deleteAllTasks() async {
    await DbHelper.deleteAll();
    // Get.snackbar('All Tasks Deleted', 'You Deleted All Tasks',
    //     snackPosition: SnackPosition.BOTTOM,
    //     backgroundColor: Colors.white,
    //     colorText: Colors.pink,
    //     icon: const Icon(
    //       Icons.cleaning_services_rounded,
    //       size: 25,
    //       color: Colors.pink,
    //     ));
    getTasks();
  }

  setTaskAsCompleted({required int taskId}) async {
    await DbHelper.update(taskId);
    // Get.snackbar('Task Set As Completed', 'Good Job, You Complete a Task',
    //     snackPosition: SnackPosition.BOTTOM,
    //     backgroundColor: Colors.white,
    //     colorText: primaryClr,
    //     icon: const Icon(
    //       Icons.done_outline_rounded,
    //       size: 25,
    //       color: primaryClr,
    //     ));
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