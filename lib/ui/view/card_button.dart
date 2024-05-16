import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  const CardButton({
    super.key,
    this.alignment,
    this.color,
    this.margin,
    this.padding = const EdgeInsets.all(16.0),
    this.radius = 12.0,
    this.elevation = 4.0,
    this.constraints,
    this.onPressed,
    required this.child,
  });

  final AlignmentGeometry? alignment;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double radius;
  final BoxConstraints? constraints;
  final double? elevation;
  final VoidCallback? onPressed;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      margin: margin,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        elevation: elevation,
        child: InkWell(
          radius: radius,
          borderRadius: BorderRadius.circular(radius),
          onTap: onPressed,
          child: Container(
            padding: padding,
            constraints: constraints,
            child: child,
          ),
        ),
      ),
    );
  }
}
