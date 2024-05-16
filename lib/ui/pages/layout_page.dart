import 'dart:async';

import 'package:flutter/material.dart';
import 'package:xposedev_desktop/extensions/context_ext.dart';

import '../../socket/socket_helper.dart';
import '../state/content_state.dart';
import '../view/card_button.dart';
import 'common_toggle_page.dart';

class LayoutPage extends StatefulWidget {
  const LayoutPage({super.key});

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  final _key = "getLayout";
  final _layoutMsg = ValueNotifier(ContentState.layout);
  final _searchToggle = ValueNotifier(false);

  @override
  void dispose() {
    _layoutMsg.dispose();
    _searchToggle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _layoutMsg,
      builder: (ctx, value, child) {
        return CommonTogglePage(
          content: value.toString(),
          isSearch: _searchToggle,
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CardButton(
                onPressed: () {
                  if (value.toString().isEmpty) {
                    ctx.showBannerMessage("被搜索的内容为空");
                  } else {
                    _searchToggle.value = !_searchToggle.value;
                  }
                },
                child: const Icon(
                  Icons.search,
                  size: 18.0,
                ),
              ),
              CardButton(
                onPressed: () {
                  _searchToggle.value = false;

                  StringBuffer buffer = StringBuffer();
                  Timer? timer;
                  //这里大文本会分段多次回调，延迟500ms拼接
                  SocketHelper.sendMessage(_key, (key, msg) {
                    if (!key.startsWith(_key)) return;

                    buffer.write(msg);
                    timer?.cancel();
                    timer = Timer(const Duration(milliseconds: 500), () {
                      _layoutMsg.value = buffer;
                      ContentState.layout = buffer;
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
      },
    );
  }
}
