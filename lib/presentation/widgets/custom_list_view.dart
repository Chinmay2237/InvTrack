import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class CustomListView extends StatelessWidget {
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final Axis scrollDirection;
  final double spacing;

  const CustomListView({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    this.scrollDirection = Axis.vertical,
    this.spacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: ListView.separated(
        scrollDirection: scrollDirection,
        itemCount: itemCount,
        separatorBuilder: (context, index) => scrollDirection == Axis.vertical
            ? SizedBox(height: spacing)
            : SizedBox(width: spacing),
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: scrollDirection == Axis.vertical ? 50.0 : 0,
              horizontalOffset: scrollDirection == Axis.horizontal ? 50.0 : 0,
              child: FadeInAnimation(
                child: itemBuilder(context, index),
              ),
            ),
          );
        },
      ),
    );
  }
}
