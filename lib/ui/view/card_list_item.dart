import 'package:flutter/material.dart';

import '../../extensions/context_ext.dart';
import '../item/json_list_item.dart';
import 'card_button.dart';

typedef CardListItemOnPressed = void Function(int index, JsonListItem item);

class CardListItem extends StatefulWidget {
  const CardListItem({
    super.key,
    required this.index,
    required this.item,
    this.textColor,
    this.onPressed,
  });

  final int index;
  final JsonListItem item;
  final Color? textColor;
  final CardListItemOnPressed? onPressed;

  @override
  State<CardListItem> createState() => _CardListItemState();
}

class _CardListItemState extends State<CardListItem> {
  @override
  Widget build(BuildContext context) {
    return CardButton(
      onPressed: widget.onPressed == null ? null : () => widget.onPressed?.call(widget.index, widget.item),
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left: widget.item.deep * 8.0, top: 4.0, bottom: 4.0),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      elevation: null,
      child: Text(
        widget.item.title,
        style: context.theme.textTheme.bodyMedium?.copyWith(color: widget.textColor),
      ),
    );
  }
}
