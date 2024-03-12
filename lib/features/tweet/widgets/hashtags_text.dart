import 'package:flutter/material.dart';
import 'package:tweetify/theme/pallete.dart';

class HashTagText extends StatelessWidget {
  final String text;
  const HashTagText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textspans = [];
    text.split(' ').forEach((element) {
      if (element.startsWith('#')) {
        textspans.add(TextSpan(
          text: '$element ',
          style: const TextStyle(
              color: Pallete.blueColor,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ));
      } else if (element.startsWith('www.') ||
          element.startsWith('https://') ||
          element.startsWith('http://')) {
        textspans.add(
          TextSpan(
            text: '$element ',
            style: const TextStyle(
              color: Pallete.blueColor,
              fontSize: 18,
            ),
          ),
        );
      } else {
        textspans.add(TextSpan(
          text: '$element ',
          style: const TextStyle(
            fontSize: 18,
            color: Pallete.whiteColor,
          ),
        ));
      }
    });
    return RichText(
        text: TextSpan(
      children: textspans,
    ));
  }
}
