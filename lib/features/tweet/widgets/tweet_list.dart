import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tweetify/common/common.dart';
import 'package:tweetify/common/error_page.dart';
import 'package:tweetify/features/tweet/controller/tweet_controller.dart';
import 'package:tweetify/features/tweet/widgets/tweet_card.dart';

class TweetList extends ConsumerWidget {
  const TweetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getTweetsProvider).when(
          data: (tweets) {
            return ListView.builder(
              itemCount: tweets.length,
              itemBuilder: (context, index) {
                final tweet = tweets[index];
                return TweetCard(tweet: tweet);
              },
            );
          },
          error: (error, stacktrace) => ErrorPage(errorText: error.toString()),
          loading: () => const Loader(),
        );
  }
}