import 'dart:ui';

import 'package:flutter/material.dart';

enum TogglePageType {
  first,
  second,
}

class TogglePageController {
  final _controller = PageController();
  var _currentPage = TogglePageType.first;

  void toFirst() {
    _currentPage = TogglePageType.first;
    _controller.jumpToPage(0);
  }

  void toSecond() {
    _currentPage = TogglePageType.second;
    _controller.jumpToPage(1);
  }

  void toggle() {
    if (_controller.page == 0) {
      toSecond();
    } else {
      toFirst();
    }
  }

  void animateToFirst() {
    _currentPage = TogglePageType.first;
    _controller.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void animateToSecond() {
    _currentPage = TogglePageType.second;
    _controller.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void animateToggle() {
    if (_controller.page == 0) {
      animateToSecond();
    } else {
      animateToFirst();
    }
  }

  TogglePageType get currentPage => _currentPage;
}

class TogglePage extends StatefulWidget {
  const TogglePage({
    super.key,
    required this.controller,
    required this.firstPage,
    required this.secondPage,
  });

  final TogglePageController controller;
  final Widget firstPage;
  final Widget secondPage;

  @override
  State<TogglePage> createState() => _TogglePageState();
}

class _TogglePageState extends State<TogglePage> {
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      controller: widget.controller._controller,
      itemCount: 2,
      itemBuilder: (context, index) {
        return index == 0 ? widget.firstPage : widget.secondPage;
      },
    );
  }

  @override
  void dispose() {
    widget.controller._controller.dispose();
    super.dispose();
  }
}
