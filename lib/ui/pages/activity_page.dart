import 'dart:async';

import 'package:flutter/material.dart';

import '../../socket/socket_helper.dart';
import '../state/content_state.dart';
import '../view/card_button.dart';
import 'common_toggle_page.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final _key = "getActivity";
  final _activityMsg = ValueNotifier(ContentState.activity);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _activityMsg,
        builder: (ctx, value, child) {
          return CommonTogglePage(
            content: value.toString(),
            floatingActionButton: CardButton(
              onPressed: () {
                StringBuffer buffer = StringBuffer();
                Timer? timer;
                //这里大文本会分段多次回调，延迟500ms拼接
                SocketHelper.sendMessage(_key, (key, msg) {
                  if (!key.startsWith(_key)) return;

                  buffer.write(msg);
                  timer?.cancel();
                  timer = Timer(const Duration(milliseconds: 500), () {
                    _activityMsg.value = buffer;
                    ContentState.activity = buffer;
                  });
                });
              },
              child: const Icon(
                Icons.refresh,
                size: 18.0,
              ),
            ),
          );
        });
  }
}
