import 'dart:async';
import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../services/task_service.dart';


class TaskProvider extends ChangeNotifier {

  final TaskService _taskService = TaskService();

  List<TaskModel> _tasks = [];

  List<TaskModel> get tasks => _tasks;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  StreamSubscription<List<TaskModel>>? _taskSubscription;

  void listenTasks(String userId) {

    _isLoading = true;
    notifyListeners();

    _taskSubscription = _taskService
        .getTasks(userId)
        .listen((taskList) {

          _tasks = taskList;

          _isLoading = false;

          notifyListeners();

        });

  }

  Future<void> addTask(TaskModel task) async {

    await _taskService.createTask(task);

  }

  Future<void> updateTask(TaskModel task) async {

    await _taskService.updateTask(task);

  }

  Future<void> deleteTask(String taskId) async {

    await _taskService.deleteTask(taskId);

  }

  @override
  void dispose() {

    _taskSubscription?.cancel();

    super.dispose();

  }

}