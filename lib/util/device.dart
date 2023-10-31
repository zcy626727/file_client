
import 'dart:io';

import 'package:flutter/foundation.dart';

//判断设备种类
class Device{
  //移动设备
  static bool get isMobileDevice => !kIsWeb && (Platform.isIOS || Platform.isAndroid);
  //桌面设备
  static bool get isDesktopDevice =>
      !kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux);
  //移动设备或web
  static bool get isMobileDeviceOrWeb => kIsWeb || isMobileDevice;
  //桌面设备或web
  static bool get isDesktopDeviceOrWeb => kIsWeb || isDesktopDevice;
  static bool get isWeb => kIsWeb;
}