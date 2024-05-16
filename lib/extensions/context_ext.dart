import 'dart:async';

import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  //获取 ThemeData
  ThemeData get theme => Theme.of(this);

  //获取 MediaQueryData
  MediaQueryData get media => MediaQuery.of(this);

  //跳转某个路由
  Future<T?> pushRoute<T extends Object?>(Route<T> route) {
    return Navigator.push(this, route);
  }

  //弹出顶层路由
  void popRoute() {
    return Navigator.pop(this);
  }

  //显示底部提示
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackMessage(String message) {
    return showSnackBar(
      SnackBar(
        content: Text(message),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      ),
    );
  }

  // 显示底部提示
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(SnackBar snackBar) {
    return ScaffoldMessenger.of(this).showSnackBar(snackBar);
  }

  // 显示一个定时隐藏的顶部提示
  ScaffoldFeatureController<MaterialBanner, MaterialBannerClosedReason> showBannerMessage(
    String message, {
    Duration? duration = const Duration(seconds: 3),
  }) {
    Timer? timer;
    if (duration != null) {
      timer = Timer(duration, () {
        ScaffoldMessenger.of(this).hideCurrentMaterialBanner();
      });
    }

    return showMaterialBanner(
      MaterialBanner(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        backgroundColor: theme.colorScheme.surfaceVariant,
        content: Text(message),
        actions: [
          IconButton(
            onPressed: () {
              timer?.cancel();
              ScaffoldMessenger.of(this).hideCurrentMaterialBanner();
            },
            icon: const Icon(
              Icons.close,
              size: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  // 显示顶部提示
  ScaffoldFeatureController<MaterialBanner, MaterialBannerClosedReason> showMaterialBanner(MaterialBanner banner) {
    return ScaffoldMessenger.of(this).showMaterialBanner(banner);
  }
}
