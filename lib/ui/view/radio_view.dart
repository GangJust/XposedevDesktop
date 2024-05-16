import 'package:flutter/material.dart';

import '../../extensions/context_ext.dart';

class RadioGroupContainer extends StatefulWidget {
  const RadioGroupContainer({
    super.key,
    this.initialSelected = 0,
    this.radius = 16.0,
    this.spacing = 2.0,
    this.elevation = 1.0,
    this.selectedColor,
    this.padding,
    required this.onSelected,
    required this.children,
  }) : assert(children.length > 0);

  final int initialSelected;
  final double radius;
  final double spacing;
  final double elevation;
  final Color? selectedColor;
  final EdgeInsetsGeometry? padding;
  final ValueChanged<int> onSelected;
  final List<RadioContainer> children;

  @override
  State<RadioGroupContainer> createState() => _RadioGroupContainerState();
}

class _RadioGroupContainerState extends State<RadioGroupContainer> {
  var _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: widget.elevation,
      borderRadius: BorderRadius.circular(widget.radius),
      child: Padding(
        padding: widget.padding ?? const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: widget.children.map((it) {
            var spacePadding = EdgeInsets.symmetric(horizontal: widget.spacing);
            if (widget.children.indexOf(it) == 0) {
              spacePadding = EdgeInsets.only(right: widget.spacing);
            } else if (widget.children.indexOf(it) == widget.children.length - 1) {
              spacePadding = EdgeInsets.only(left: widget.spacing);
            }

            return Padding(
              padding: spacePadding,
              child: Material(
                color: _selected == it.value
                    ? (widget.selectedColor ?? context.theme.colorScheme.tertiaryContainer)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(widget.radius),
                child: InkWell(
                  borderRadius: BorderRadius.circular(widget.radius),
                  onTap: () {
                    setState(() {
                      _selected = it.value;
                      widget.onSelected(_selected);
                    });
                  },
                  child: it,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class RadioContainer extends StatelessWidget {
  const RadioContainer({
    super.key,
    required this.value,
    this.padding,
    required this.child,
  });

  final int value;
  final EdgeInsetsGeometry? padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: child,
    );
  }
}
