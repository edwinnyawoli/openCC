import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  const Label({Key key, this.child, this.padding}) : super(key: key);
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: child,
    );
  }
}
