import 'package:flutter/material.dart';

List times(TimeOfDay time) {
  List showTime = [];
  if(time.minute < 10) {
    if(time.hour > 12) {
      showTime.addAll([time.hour - 12, "0${time.minute}", "PM"]);
      return showTime;
    } else if(time.hour == 0) {
      showTime.addAll([12, "0${time.minute}", "AM"]);
      return showTime;
    } else {
      showTime.addAll([time.hour, "0${time.minute}", "PM"]);
      return showTime;
    }
  } else {
    if(time.hour > 12) {
      showTime.addAll([time.hour - 12, time.minute, "PM"]);
      return showTime;
    } else if(time.hour == 0) {
      showTime.addAll([12, time.minute, "AM"]);
      return showTime;
    } else {
      showTime.addAll([time.hour, time.minute, "PM"]);
      return showTime;
    }
  }
}