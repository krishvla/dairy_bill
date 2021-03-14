import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';

void rippleLoader() {
  EasyLoading.instance
    ..displayDuration = const Duration(seconds: 3)
    ..indicatorType = EasyLoadingIndicatorType.dualRing
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..maskType = EasyLoadingMaskType.clear
    ..maskColor = Color.fromARGB(255, 2, 170, 176).withOpacity(0.5)
    ..animationStyle = EasyLoadingAnimationStyle.offset;
}

void notificationToast() {
  EasyLoading.instance
    ..displayDuration = const Duration(seconds: 3)
    ..indicatorType = EasyLoadingIndicatorType.ripple
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..maskType = EasyLoadingMaskType.black
    ..maskColor = Color.fromARGB(255, 2, 170, 176).withOpacity(0.5)
    ..dismissOnTap = true
    ..animationStyle = EasyLoadingAnimationStyle.offset;
}

void toastStyle() {
  EasyLoading.instance
    ..displayDuration = const Duration(seconds: 3)
    ..toastPosition = EasyLoadingToastPosition.top
    ..loadingStyle = EasyLoadingStyle.light
    ..animationStyle = EasyLoadingAnimationStyle.scale;
}
