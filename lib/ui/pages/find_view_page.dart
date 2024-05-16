import 'dart:async';

import 'package:flutter/material.dart';

import '../../socket/socket_helper.dart';
import '../state/content_state.dart';
import '../view/card_button.dart';
import 'common_toggle_page.dart';

class FindViewPage extends StatefulWidget {
  const FindViewPage({super.key});

  @override
  State<FindViewPage> createState() => _FindViewPageState();
}

class _FindViewPageState extends State<FindViewPage> {
  final _key = "findViewById";
  final _viewIdTextController = TextEditingController();
  final _findViewMsg = ValueNotifier(ContentState.findView);

  @override
  void dispose() {
    _viewIdTextController.dispose();
    _findViewMsg.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _findViewMsg,
        builder: (ctx, value, child) {
          return CommonTogglePage(
            content: value.toString(),
            floatingActionButton: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CardButton(
                  constraints: const BoxConstraints(maxWidth: 180.0),
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: TextField(
                    controller: _viewIdTextController,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: "请输入视图ID",
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                CardButton(
                  onPressed: () {
                    StringBuffer buffer = StringBuffer();
                    Timer? timer;
                    //这里大文本会分段多次回调，延迟500ms拼接
                    SocketHelper.sendMessage("$_key ${_viewIdTextController.text}", (key, msg) {
                      if (!key.startsWith(_key)) return;

                      buffer.write(msg);
                      timer?.cancel();
                      timer = Timer(const Duration(milliseconds: 500), () {
                        _findViewMsg.value = buffer;
                        ContentState.findView = buffer;
                      });
                    });
                  },
                  child: const Icon(
                    Icons.refresh,
                    size: 18.0,
                  ),
                ),
              ],
            ),
          );
        });
  }
}
