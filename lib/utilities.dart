import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class Utilities {
  static showToast({required String msg, Toast? length, required bool isError}) {
    Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.BOTTOM,
        // backgroundColor: isError ? Colors.red : AppColors.blue,
        toastLength: length ?? Toast.LENGTH_LONG,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static bool validatingEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (regex.hasMatch(value)) {
      return true;
    } else {
      return false;
    }
  }
 static String getYoutubeThumbnail(String videoUrl) {
    // Extract the video ID
    final uri = Uri.parse(videoUrl);
    String? videoId;

    if (uri.host.contains('youtu.be')) {
      videoId = uri.pathSegments.first;
    } else if (uri.host.contains('youtube.com')) {
      videoId = uri.queryParameters['v'];
    }

    if (videoId == null) {
      throw Exception('Invalid YouTube URL');
    }

    return 'https://img.youtube.com/vi/$videoId/0.jpg';
  }
  static String getCurrentPosImg(double pitch) {
    if (pitch > 75) {
      return "assets/images/right_pos.png";
    } else if (pitch > 65) {
      return "assets/images/15_pos.png";
    } else if (pitch > 55) {
      return "assets/images/30_pos.png";
    } else {
      return "assets/images/60_pos.png";
    }
  }

  static String getDateFormated(DateTime date) {
    DateTime today = DateTime.now();
    DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
    if (date.year == today.year && date.month == today.month && date.day == today.day) {
      return "Today";
    } else if (date.year == yesterday.year &&
        yesterday.month == yesterday.month &&
        date.day == yesterday.day) {
      return "Yesterday";
    } else {
      return DateFormat('EEE d of MMM, yyyy', "en").format(date);
    }
  }

  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return '${hours != "00" ? "$hours h, " : ""}${minutes != "00" ? "$minutes m, " : ""}${seconds != "00" ? "$seconds s" : ""}';
  }
}