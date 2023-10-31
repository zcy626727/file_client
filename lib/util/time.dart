class DateTimeUtil {
  //时间格式化
  static String durationTimeFormat(Duration d) {
    var timeStr = d.toString();
    int start = 0;
    int end = timeStr.lastIndexOf(".");
    int width = 8;
    if (d.inHours == 0) {
      //小于一小时只显示分钟和秒
      start = timeStr.indexOf(":") + 1;
      width = 5;
    } else if (d.inHours < 24) {
      width = 8;
    } else {
      //超过24小时
      return timeStr;
    }
    return timeStr.substring(start, end).padLeft(width, "0");
  }

  static String durationZeroTimeFormat(bool hasHour) {
    if (hasHour) {
      return "00:00:00";
    } else {
      return "00:00";
    }
  }
}
