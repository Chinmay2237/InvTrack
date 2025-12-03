import 'package:flutter/material.dart';

class ContentContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const ContentContainer({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWeb = constraints.maxWidth > 800;
        return Center(
          child: Container(
            width: isWeb ? 1200 : double.infinity,
            padding: padding ?? const EdgeInsets.all(16.0),
            child: child,
          ),
        );
      },
    );
  }
}
