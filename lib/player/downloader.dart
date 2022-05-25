import 'dart:isolate';
import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';

const debug = true;

class Downloader {
  List<_TaskInfo> tasks;
  List<_ItemHolder> items;
  bool _isLoading;
  bool _permissionReady;
  String _localPath;
  ReceivePort _port = ReceivePort();
  TargetPlatform platform;
  List<Map<String, String>> videos;
  Function setStateFn;

  void initStates(BuildContext context) {
    bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);

    _isLoading = true;
    _permissionReady = false;

    prepare();
  }

  void disposes() {
    unbindBackgroundIsolate();
  }

  void bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      unbindBackgroundIsolate();
      bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) async {
      if (debug) {
        print('UI Isolate Callback: $data');
      }
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      if (tasks != null && tasks.isNotEmpty) {
        final task = tasks.firstWhere((task) => task.taskId == id);
        setStateFn(() {
          task.status = status;
          task.progress = progress;
        });
        final loadTasks = await FlutterDownloader.loadTasks();
        loadTasks.forEach((task) {
          for (_TaskInfo info in tasks) {
            if (info.link == task.url) {
              info.taskId = task.taskId;
              info.fileName = task.filename;
              info.savedDir = task.savedDir;
            }
          }
        });
      }
    });
  }

  void unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    if (debug) {
      print(
          'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    }
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  Future<void> retryRequestPermission() async {
    final hasGranted = await checkPermission();

    if (hasGranted) {
      await prepareSaveDir();
    }

    setStateFn(() {
      _permissionReady = hasGranted;
    });
  }

  void requestDownload(_TaskInfo task) async {
    task.taskId = await FlutterDownloader.enqueue(
        url: task.link,
        headers: {"auth": "test_for_sql_encoding"},
        savedDir: _localPath,
        showNotification: true,
        openFileFromNotification: false);
  }

  void cancelDownload(_TaskInfo task) async {
    await FlutterDownloader.cancel(taskId: task.taskId);
  }

  void pauseDownload(_TaskInfo task) async {
    await FlutterDownloader.pause(taskId: task.taskId);
  }

  void resumeDownload(_TaskInfo task) async {
    String newTaskId = await FlutterDownloader.resume(taskId: task.taskId);
    task.taskId = newTaskId;
  }

  void retryDownload(_TaskInfo task) async {
    String newTaskId = await FlutterDownloader.retry(taskId: task.taskId);
    task.taskId = newTaskId;
  }

  Future<bool> openDownloadedFile(_TaskInfo task) {
    if (task != null) {
      return FlutterDownloader.open(taskId: task.taskId);
    } else {
      return Future.value(false);
    }
  }

  void delete(_TaskInfo task) async {
    await FlutterDownloader.remove(
        taskId: task.taskId, shouldDeleteContent: true);
    await prepare();
    setStateFn(() {});
  }

  Future<bool> checkPermission() async {
    if (platform == TargetPlatform.android) {
      final status1 = await Permission.storage.status;
      if (status1 != PermissionStatus.granted) {
        final result1 = await Permission.storage.request();
        if (result1 == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<Null> prepare() async {
    final loadTasks = await FlutterDownloader.loadTasks();

    int count = 0;
    tasks = [];
    items = [];

    tasks.addAll(videos
        .map((video) => _TaskInfo(name: video['name'], link: video['link'])));

    for (int i = count; i < tasks.length; i++) {
      items.add(_ItemHolder(name: tasks[i].name, task: tasks[i]));
      count++;
    }

    loadTasks.forEach((task) {
      for (_TaskInfo info in tasks) {
        if (info.link == task.url) {
          info.taskId = task.taskId;
          info.status = task.status;
          info.progress = task.progress;
          info.fileName = task.filename;
          info.savedDir = task.savedDir;
        }
      }
    });

    _permissionReady = await checkPermission();

    if (_permissionReady) {
      await prepareSaveDir();
    }

    setStateFn(() {
      _isLoading = false;
    });
  }

  Future<void> prepareSaveDir() async {
    _localPath = (await findLocalPath());
  }

  Future<String> findLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  void printData() {
    print('printData() called.');
    for (_ItemHolder itemHolder in items) {
      print('Item Name : ' + itemHolder.name);
    }
  }
}

class _TaskInfo {
  final String name;
  final String link;

  String taskId;
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;
  String fileName;
  String savedDir;

  _TaskInfo({this.name, this.link});
}

class _ItemHolder {
  final String name;
  final _TaskInfo task;

  _ItemHolder({this.name, this.task});
}
