import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../extensions/context_ext.dart';
import '../../socket/socket_helper.dart';
import 'home_router.dart';

class ConnectRoute extends StatefulWidget {
  const ConnectRoute({super.key});

  @override
  State<ConnectRoute> createState() => _ConnectRouteState();
}

class _ConnectRouteState extends State<ConnectRoute> {
  late final ValueNotifier _isLoading;
  late final TextEditingController _ipController;
  late final TextEditingController _portController;

  @override
  void initState() {
    _isLoading = ValueNotifier(false);
    _ipController = TextEditingController(text: "");
    _portController = TextEditingController(text: "2345");
    super.initState();
  }

  @override
  void dispose() {
    _isLoading.dispose();
    _ipController.dispose();
    _portController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "请在同一Wifi环境下填入XposeDev提供的ip地址和端口号",
            style: context.theme.textTheme.bodyMedium?.copyWith(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              height: 3.0,
            ),
          ),
          Text(
            "然后运行宿主App, 进行下一步",
            style: context.theme.textTheme.bodyMedium?.copyWith(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: context.theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  constraints: const BoxConstraints(maxWidth: 380.0),
                  child: TextField(
                    controller: _ipController,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    style: context.theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      hintText: "ip address",
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(":"),
                ),
                Container(
                  constraints: const BoxConstraints(maxWidth: 96.0),
                  child: TextField(
                    controller: _portController,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                    ],
                    style: context.theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      hintText: "port",
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32.0),
          Container(
            constraints: const BoxConstraints(minHeight: 54.0, minWidth: 54.0),
            child: ValueListenableBuilder(
              valueListenable: _isLoading,
              builder: (ctx, value, child) {
                if (value) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  );
                }

                ///
                return OutlinedButton(
                  onPressed: _onNext,
                  style: OutlinedButton.styleFrom(
                    textStyle: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 160.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("下一步"),
                        Icon(
                          Icons.chevron_right,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void _onNext() {
    final ip = _ipController.text;
    final port = _portController.text;

    if (ip.trim().isEmpty || port.trim().isEmpty) {
      context.showBannerMessage("请输入ip地址和端口号");
      return;
    }

    // socket连接
    _isLoading.value = true;
    SocketHelper.connect(
      ip,
      int.parse(port),
      onClose: () {
        context.popRoute();

        // message
        context.showBannerMessage("已断开连接");
      },
      onConnect: (message) {
        _isLoading.value = false;

        // message
        context.showBannerMessage(message);

        if (message == "连接成功") {
          context.pushRoute(MaterialPageRoute(builder: (ctx) {
            return const HomeRouter();
          }));
        }
      },
    );
  }
}
