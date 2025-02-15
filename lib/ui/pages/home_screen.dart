import 'dart:developer';

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
//import 'package:tasky/services/notification_services%20from%20course.dart';

import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../../services/notification_seervices.dart';
import '../../services/theme_services.dart';
import '../size_config.dart';
import '../theme.dart';
import '../widgets/mybutton.dart';
import '../widgets/task_tile.dart';
import 'add_task_screen.dart';

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
              await Get.to(() => const AddTaskScreen());
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
      child: ListView.builder(
        itemBuilder: (context, index) {
          var task = _taskController.taskList[index];
          var hourr = task.startTime.toString().split(':')[0];
          var minutee = task.startTime.toString().split(':')[1];

          int hour;
          int minute;
          DateTime dateTime;
          RegExp regex = RegExp(r'(\d+):(\d+)\s*(AM|PM)');
          var match = regex.firstMatch(task.startTime!);

          if (match != null) {
            hour = int.parse(match.group(1)!);
            minute = int.parse(match.group(2)!);
            bool isPM = match.group(3) == "PM";

            // Convert to 24-hour format
            if (isPM && hour != 12) hour += 12;
            if (!isPM && hour == 12) hour = 0;

            dateTime = DateTime.now().copyWith(hour: hour, minute: minute);
          } else {
            hour = 1;
            minute = 0;
            dateTime = DateTime.now();
            log('from else hours = $hour        and min = $minute');
          }

          // var date = DateFormat.jm().parse(task.startTime!);
          //var myTime = DateFormat('HH:MM').format(dateTime);
          // log('myTime = $myTime   ');
          // log('date = $date   ');
          NotifyHelper().scheduledNotification(
            hour,
            minute,
            task,
          );
          return AnimationConfiguration.staggeredList(
            duration: const Duration(milliseconds: 1000),
            position: index,
            child: SlideAnimation(
              horizontalOffset: 300,
              child: FadeInAnimation(
                child: GestureDetector(
                  onTap: () {
                    _showBottomSheet(
                      context,
                      task,
                    );
                  },
                  child: TaskTile(
                    task,
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: _taskController.taskList.length,
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

            // NotifyHelper().displayNotification(
            //     title: 'theme changed nowwwww ', body: 'body');
            // NotifyHelper().scheduledNotification(
            //     17,
            //     37,
            //     Task(
            //       id: 1,
            //       isCompleted: 1,
            //       color: 1,
            //       note: 'note Something ',
            //       title: 'Note 2',
            //       startTime: '12:45',
            //       endTime: '6:00',
            //     ));
            await Future.delayed(const Duration(milliseconds: 70));
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
