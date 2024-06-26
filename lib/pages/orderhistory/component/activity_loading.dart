import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ActivityLoading extends StatelessWidget {
  const ActivityLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Shimmer.fromColors(
                  baseColor: Colors.grey.withOpacity(0.5),
                  highlightColor: Colors.white,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    height: 170,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                  )),
            );
          },
          childCount: 5,
        ));
  }
}