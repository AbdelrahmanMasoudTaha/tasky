import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:tasky/models/task.dart';
import 'package:tasky/services/notification_seervices.dart';
import 'package:tasky/services/theme_services.dart';
import 'package:tasky/ui/pages/add_task_screen.dart';
import 'package:tasky/ui/size_config.dart';
import 'package:tasky/ui/theme.dart';
import 'package:tasky/ui/widgets/my_input_field.dart';
import 'package:tasky/ui/widgets/task_tile.dart';

import '../../controllers/task_controller.dart';
import '../widgets/mybutton.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late NotifyHelper notifyHelper;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializNotification();
  }

  final TaskController _taskController = Get.put(TaskController());
  DateTime _selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: _appBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _addTaskBar(),
            _addDateBar(),
            _showTasks(),
          ],
        ),
      ),
    );
  }

  Widget _addTaskBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text(
                'Today',
                style: headingStyle,
              )
            ],
          ),
          MyButton(
            lable: '+ Add Task',
            onTap: () async {
              await Get.to(const AddTaskScreen());
              //ThemeServices().switchMode();

              _taskController.getTasks();
            },
          )
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 6, left: 14),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 70,
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dayTextStyle: GoogleFonts.lato(
            fontWeight: FontWeight.w600, fontSize: 20, color: Colors.grey),
        dateTextStyle: GoogleFonts.lato(
            fontWeight: FontWeight.w600, fontSize: 18, color: Colors.grey),
        monthTextStyle: GoogleFonts.lato(
            fontWeight: FontWeight.w600, fontSize: 16, color: Colors.grey),
        initialSelectedDate: DateTime.now(),
        onDateChange: (selectedDate) {
          setState(() {
            _selectedDate = selectedDate;
          });
        },
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _showBottomSheet(
            context,
            Task(
              title: 'title 1',
              note: 'sdfdfasf',
              isCompleted: 1,
              startTime: '12:15',
              endTime: '8:00',
              color: 1,
            ),
          );
        },
        child: TaskTile(
          Task(
            title: 'title 1',
            note: 'sdfdfasf',
            isCompleted: 0,
            startTime: '12:15',
            endTime: '8:00',
            color: 1,
          ),
        ),
      ),

      //     child: Obx(
      //   () {
      //     if (_taskController.taskList.isEmpty) {
      //       return _noTaskMsg();
      //     } else {
      //       return Container(
      //         height: 0,
      //       );
      //     }
      //   },
      // ),
    );
  }

  AppBar _appBar() => AppBar(
        leading: IconButton(
          icon: Icon(
            ThemeServices().theme == ThemeMode.dark
                ? Icons.wb_sunny_outlined
                : Icons.nightlight_round_outlined,
            color: ThemeServices().theme == ThemeMode.dark
                ? Colors.white
                : darkGreyClr,
            size: 24,
          ),
          onPressed: () async {
            ThemeServices().switchMode();

            NotifyHelper()
                .displayNotification(title: 'theme changed', body: 'body');
            NotifyHelper().scheduledNotification();
            await Future.delayed(const Duration(milliseconds: 100));
            setState(() {}); // Wait for rebuild
          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('images/person.jpeg'),
              radius: 24,
            ),
          ),
        ],
      );

  _buildButtomSheet({
    required String lable,
    required Function() onTap,
    required Color clr,
    bool isClosed = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: isClosed
                  ? Get.isDarkMode
                      ? Colors.grey[200]!
                      : Colors.grey[600]!
                  : clr,
            ),
            borderRadius: BorderRadius.circular(20),
            color: isClosed ? Colors.transparent : clr),
        child: Center(
          child: Text(lable,
              style: isClosed
                  ? titleStyle
                  : titleStyle.copyWith(color: Colors.white)),
        ),
      ),
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 4),
        width: SizeConfig.screenWidth,
        height: (SizeConfig.orientation == Orientation.landscape)
            ? (task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.6
                : SizeConfig.screenHeight * 0.8)
            : (task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.3
                : SizeConfig.screenHeight * 0.4),
        color: Get.isDarkMode ? darkHeaderClr : Colors.white,
        child: Column(
          children: [
            Flexible(
              child: Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color:
                        Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
              ),
            ),
            task.isCompleted == 1
                ? Container()
                : _buildButtomSheet(
                    lable: 'Task Completed',
                    onTap: () {},
                    clr: primaryClr,
                  ),
            task.isCompleted == 1
                ? Container()
                : Divider(
                    color: Get.isDarkMode ? Colors.grey : darkGreyClr,
                    endIndent: 20,
                    indent: 20,
                  ),
            _buildButtomSheet(
              lable: 'Delet',
              onTap: () {},
              clr: primaryClr,
            ),
            Divider(
              color: Get.isDarkMode ? Colors.grey : darkGreyClr,
              endIndent: 20,
              indent: 20,
            ),
            _buildButtomSheet(
                lable: 'Cancel',
                onTap: () {
                  Get.back();
                },
                clr: primaryClr),
          ],
        ),
      ),
    ));
  }

  _noTaskMsg() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 2000),
          child: SingleChildScrollView(
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: SizeConfig.orientation == Orientation.landscape
                  ? Axis.horizontal
                  : Axis.vertical,
              children: [
                SizeConfig.orientation == Orientation.landscape
                    ? const SizedBox(
                        height: 10,
                      )
                    : const SizedBox(
                        height: 230,
                      ),
                SvgPicture.asset(
                  'images/task.svg',
                  semanticsLabel: 'Task',
                  color: primaryClr.withOpacity(0.65),
                  height: 100,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    'You do not have any Tasks yet! \n Add new tasks to make your day prefect',
                    style: subTitleStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizeConfig.orientation == Orientation.landscape
                    ? const SizedBox(
                        height: 120,
                      )
                    : const SizedBox(
                        height: 180,
                      ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
