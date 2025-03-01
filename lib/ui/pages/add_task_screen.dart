// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tasky/controllers/task_controller.dart';
import 'package:tasky/ui/theme.dart';
import 'package:tasky/ui/widgets/mybutton.dart';

import '../../models/task.dart';
import '../widgets/my_input_field.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  // ignore: unused_field, prefer_final_fields
  String _startDate = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endDate = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();
  int _selecteddRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monhtly'];
  int _selctedColor = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Add Task',
                style: headingStyle,
              ),
              MyInputField(
                title: 'title',
                hint: 'Enter title here',
                controller: _titleController,
              ),
              MyInputField(
                title: 'Note',
                hint: 'Enter note here',
                controller: _noteController,
              ),
              MyInputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    _getDateFromUser();
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: MyInputField(
                      title: 'Start Time',
                      hint: _startDate,
                      widget: IconButton(
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          _getTimeFromUser(isStartTime: true);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: MyInputField(
                      title: 'End Time',
                      hint: _endDate,
                      widget: IconButton(
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          _getTimeFromUser(isStartTime: false);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              MyInputField(
                title: 'Remind',
                hint: '$_selecteddRemind minutes early',
                widget: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: DropdownButton(
                    dropdownColor: primaryClr.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                    items: remindList
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              '$e',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    iconSize: 30,
                    elevation: 4,
                    onChanged: (value) {
                      setState(() {
                        _selecteddRemind = value!;
                      });
                    },
                    underline: Container(
                      height: 0,
                    ),
                  ),
                ),
              ),
              MyInputField(
                title: 'Repeat',
                hint: _selectedRepeat,
                widget: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: DropdownButton(
                    dropdownColor: primaryClr.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                    items: repeatList
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    iconSize: 30,
                    elevation: 4,
                    onChanged: (value) {
                      setState(() {
                        _selectedRepeat = value!;
                      });
                    },
                    underline: Container(
                      height: 0,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPalet(),
                  MyButton(
                      lable: 'Creat Task',
                      onTap: () {
                        _validateTask();
                        Get.back();
                      })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar() => AppBar(
        // backgroundColor: context.theme.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/person.jpeg'),
              radius: 24,
            ),
          ),
        ],
      );

  _validateTask() {
    if (_noteController.text.isNotEmpty && _titleController.text.isNotEmpty) {
      _addTaskToDb();
      Get.back();
    } else if (_noteController.text.isEmpty || _titleController.text.isEmpty) {
      Get.snackbar('Required Feild', "Please Fill All Feilds",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: Colors.pink,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
    } else {
      log('#########   the task dose not saved successfully   #########');
    }
  }

  _addTaskToDb() async {
    await _taskController.addTask(
        task: Task(
      title: _titleController.text,
      note: _noteController.text,
      color: _selctedColor,
      date: DateFormat.yMd().format(_selectedDate),
      endTime: _endDate,
      startTime: _startDate,
      isCompleted: 0,
      remind: _selecteddRemind,
      repeat: _selectedRepeat,
    ));
  }

  Column _colorPalet() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Color', style: titleStyle),
        const SizedBox(
          height: 5,
        ),
        Wrap(
          children: List.generate(3, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selctedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: index == 0
                      ? primaryClr
                      : index == 1
                          ? pinkClr
                          : orangeClr,
                  child: _selctedColor == index
                      ? const Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 20,
                        )
                      : null,
                ),
              ),
            );
          }),
        )
      ],
    );
  }

  void _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? _pickedTime = await showTimePicker(
        context: context,
        initialEntryMode: TimePickerEntryMode.input,
        initialTime: isStartTime
            ? TimeOfDay.fromDateTime(DateTime.now())
            : TimeOfDay.fromDateTime(
                DateTime.now().add(const Duration(minutes: 15))));
    if (_pickedTime != null) {
      String _formattedTime = _pickedTime.format(context);
      if (isStartTime) setState(() => _startDate = _formattedTime);
      if (!isStartTime) setState(() => _endDate = _formattedTime);
    } else {
      log('picked time is null');
    }
  }

  void _getDateFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
        context: context,
        initialEntryMode: DatePickerEntryMode.input,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(alwaysUse24HourFormat: false), // Force 12-hour format
            child: child!,
          );
        },
        firstDate: DateTime(
          DateTime.now().year - 1,
        ),
        lastDate: DateTime(
          DateTime.now().year + 2,
        ),
        initialDate: _selectedDate);

    if (_pickedDate != null) {
      setState(() {
        _selectedDate = _pickedDate;
      });
    } else {
      log('picked date is null');
    }
  }
}
