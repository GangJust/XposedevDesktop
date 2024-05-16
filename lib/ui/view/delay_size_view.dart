import 'package:flutter/material.dart';

class DelaySizeView extends StatelessWidget {
  const DelaySizeView({
    super.key,
    required this.onSized,
    required this.child,
  });

  final ValueChanged<Size> onSized;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!context.mounted) return;
      final renderBox = context.findRenderObject() as RenderBox?;
      onSized.call(renderBox?.size ?? Size.zero);
    });

    return child;
  }
}
