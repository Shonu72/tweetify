import 'package:flutter/material.dart';
import 'package:tweetify/theme/pallete.dart';

class FollowCount extends StatelessWidget {
  final int count;
  final String text;
  const FollowCount({super.key, required this.count, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "$count",
          style: const TextStyle(
            fontSize: 18,
            color: Pallete.whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            color: Pallete.greyColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
