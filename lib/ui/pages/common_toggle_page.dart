import 'dart:async';

import 'package:flutter/material.dart';

import '../../extensions/context_ext.dart';
import '../../utils/json_deep_utils.dart';
import '../item/json_list_item.dart';
import '../view/card_list_item.dart';
import '../view/delay_size_view.dart';
import '../view/radio_view.dart';
import '../view/toggle_page.dart';

class CommonTogglePage extends StatefulWidget {
  const CommonTogglePage({
    super.key,
    required this.content,
    this.isSearch,
    this.floatingActionButton,
  });

  final String content;
  final ValueNotifier<bool>? isSearch;
  final Widget? floatingActionButton;

  @override
  State<CommonTogglePage> createState() => _CommonTogglePageState();
}

class _CommonTogglePageState extends State<CommonTogglePage> {
  final _togglePageController = TogglePageController();
  final _overlayToolbarOpacity = ValueNotifier(0.5);

  final _firstScrollController = ScrollController();
  final _childIndex = ValueNotifier(0);
  final _childList = <JsonListItem>[];
  String _errMessage = "";
  Size _itemSize = Size.zero;
  final _searchValueController = TextEditingController();
  final _searchList = ValueNotifier(<JsonListItem>[]);
  final _currentPosition = ValueNotifier(0);

  @override
  void dispose() {
    _overlayToolbarOpacity.dispose();
    _childIndex.dispose();

    _searchValueController.dispose();
    _searchList.dispose();
    _currentPosition.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _clear();

    JsonDeepUtils.deepRunnable(widget.content, (data, deep) async {
      if (deep == -1) {
        _childIndex.value = -1;
        _errMessage = "$data";
        return;
      }

      if (data is Map) {
        _childIndex.value = _childIndex.value + 1;
        _childList.add(JsonListItem(_childIndex.value, deep, data));
      }
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(24.0),
            child: TogglePage(
              controller: _togglePageController,
              firstPage: ValueListenableBuilder(
                valueListenable: _childIndex,
                builder: (ctx, value, child) {
                  if (_childList.isEmpty) {
                    return Center(
                      child: Text(_errMessage),
                    );
                  }
                  return ListView(
                    controller: _firstScrollController,
                    children: _childList.map((it) {
                      return DelaySizeView(
                        onSized: (size) {
                          _itemSize = size;
                        },
                        child: ValueListenableBuilder(
                          valueListenable: _searchList,
                          builder: (ctx, search, child) {
                            return CardListItem(
                              index: value,
                              item: it,
                              textColor: search.contains(it) ? Colors.red : null,
                              onPressed: _showDetailDialog,
                            );
                          },
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              secondPage: ListView(
                children: [
                  SelectionArea(
                    child: Text(
                      widget.content,
                      style: context.theme.textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 16.0,
            right: 16.0,
            child: MouseRegion(
              onEnter: (e) {
                _overlayToolbarOpacity.value = 1.0;
              },
              onExit: (e) {
                _overlayToolbarOpacity.value = 0.5;
              },
              child: ValueListenableBuilder(
                  valueListenable: _overlayToolbarOpacity,
                  builder: (ctx, value, child) {
                    return AnimatedOpacity(
                      opacity: value,
                      duration: const Duration(milliseconds: 200),
                      child: Column(
                        children: [
                          RadioGroupContainer(
                            elevation: 2.0,
                            radius: 24.0,
                            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
                            onSelected: _togglePage,
                            children: const [
                              RadioContainer(
                                value: 0,
                                child: Text("View"),
                              ),
                              RadioContainer(
                                value: 1,
                                child: Text("Raw"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ),
          Positioned(
            top: 72.0,
            right: 16.0,
            child: ValueListenableBuilder<bool>(
                valueListenable: widget.isSearch ?? ValueNotifier(false),
                builder: (ctx, value, child) {
                  // Raw强制不显示搜索组件
                  value = _togglePageController.currentPage == TogglePageType.second ? false : value;

                  Timer? timer;

                  return Visibility(
                    visible: value,
                    child: SizedBox(
                      width: 240.0,
                      child: Column(
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextField(
                                controller: _searchValueController,
                                onChanged: (text) {
                                  timer?.cancel();
                                  timer = Timer(const Duration(milliseconds: 500), () {
                                    _onSearch(text);
                                  });
                                },
                                onEditingComplete: () {
                                  _onSearch(_searchValueController.text);
                                },
                                style: context.theme.textTheme.bodyMedium,
                                decoration: const InputDecoration(
                                  hintText: "请输入关键字",
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          ValueListenableBuilder(
                              valueListenable: _searchList,
                              builder: (ctx, searchList, child) {
                                return Card(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                            child: Text(
                                              "${searchList.length}个匹配项",
                                            ),
                                          ),
                                        ),
                                        ValueListenableBuilder(
                                          valueListenable: _currentPosition,
                                          builder: (ctx, position, _) {
                                            return Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                              child: Text(
                                                "$position/${searchList.length}",
                                              ),
                                            );
                                          },
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (searchList.isEmpty) return;

                                            if (_currentPosition.value <= 1) {
                                              _currentPosition.value = 1;
                                            } else {
                                              _currentPosition.value -= 1;
                                            }

                                            _firstPageListJump();
                                          },
                                          borderRadius: BorderRadius.circular(36.0),
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.arrow_upward,
                                              size: 12.0,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (searchList.isEmpty) return;

                                            if (_currentPosition.value >= searchList.length) {
                                              _currentPosition.value = searchList.length;
                                            } else {
                                              _currentPosition.value += 1;
                                            }

                                            _firstPageListJump();
                                          },
                                          borderRadius: BorderRadius.circular(36.0),
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.arrow_downward,
                                              size: 12.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
      floatingActionButton: widget.floatingActionButton,
    );
  }

  void _showDetailDialog(int index, JsonListItem item) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          child: Container(
            constraints: BoxConstraints(minWidth: ctx.media.size.width / 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: SelectionArea(
                    child: Text(
                      item.title,
                      style: ctx.theme.textTheme.titleLarge,
                    ),
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: SelectionArea(
                        child: Container(
                          constraints: BoxConstraints(minWidth: ctx.media.size.width / 2),
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                          child: Text(
                            item.toSingleJson(4),
                            maxLines: null,
                            style: ctx.theme.textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _togglePage(int index) {
    widget.isSearch?.value = false;
    switch (index) {
      case 0:
        _togglePageController.toFirst();
        break;
      case 1:
        _togglePageController.toSecond();
        break;
    }
  }

  void _onSearch(String text) {
    _searchList.value = _childList.where((it) {
      return text.trim().isNotEmpty && it.toSingleJson(0).contains(text);
    }).toList();
    if (_searchList.value.isEmpty) {
      _currentPosition.value = 0;
      _firstPageListJump();
    } else {
      _currentPosition.value = 1;
      _firstPageListJump();
    }
  }

  void _firstPageListJump() {
    if (_searchList.value.isEmpty) return;

    var position = _searchList.value[_currentPosition.value - 1].index;
    _firstScrollController.jumpTo(position * _itemSize.height - (context.media.size.height ~/ 2));
  }

  void _clear() {
    _childIndex.value = 0;
    _childList.clear();

    _searchValueController.text = "";
    _currentPosition.value = 0;
    _searchList.value = [];
  }
}
