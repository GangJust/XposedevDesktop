import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'socket/socket_helper.dart';

class WindowWrapper extends StatefulWidget {
  const WindowWrapper({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<WindowWrapper> createState() => _WindowWrapperState();
}

class _WindowWrapperState extends State<WindowWrapper> with WindowListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void onWindowClose() {
    SocketHelper.close();
    super.onWindowClose();
  }

  @override
  void onWindowFocus() {
    setState(() {});
    super.onWindowFocus();
  }
}
