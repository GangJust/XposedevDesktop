import 'dart:async';

import 'package:flutter/material.dart';

import '../../socket/socket_helper.dart';
import '../state/content_state.dart';
import '../view/card_button.dart';
import 'common_toggle_page.dart';

class FragmentPage extends StatefulWidget {
  const FragmentPage({super.key});

  @override
  State<FragmentPage> createState() => _FragmentPageState();
}

class _FragmentPageState extends State<FragmentPage> {
  final _key = "getFragment";
  final _fragmentMsg = ValueNotifier(ContentState.fragment);

  @override
  void dispose() {
    _fragmentMsg.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _fragmentMsg,
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
                  _fragmentMsg.value = buffer;
                  ContentState.fragment = buffer;
                });
              });
            },
            child: const Icon(
              Icons.refresh,
              size: 18.0,
            ),
          ),
        );
      },
    );
  }
}
