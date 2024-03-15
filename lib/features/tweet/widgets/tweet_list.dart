import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tweetify/common/common.dart';
import 'package:tweetify/common/error_page.dart';
import 'package:tweetify/constants/appwrite_constant.dart';
import 'package:tweetify/features/tweet/controller/tweet_controller.dart';
import 'package:tweetify/features/tweet/widgets/tweet_card.dart';
import 'package:tweetify/models/tweet_model.dart';

class TweetList extends ConsumerWidget {
  const TweetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getTweetsProvider).when(
          data: (tweets) {
            return ref.watch(getLatestTweetProvider).when(
                  data: (data) {
                    if (data.events.contains(
                        // this will listen to any changes in the collection and * is used for all the documents but its not a good practice
                        // need to make new database for production
                        'databases.*.collections.${AppWriteConstant.tweetCollectionId}.documents.*.create')) {
                      print(data.events);
                      tweets.insert(0, Tweet.fromMap(data.payload));
                    }
                    return ListView.builder(
                      itemCount: tweets.length,
                      itemBuilder: (context, index) {
                        final tweet = tweets[index];
                        return TweetCard(tweet: tweet);
                      },
                    );
                  },
                  error: (error, stacktrace) =>
                      ErrorPage(errorText: error.toString()),
                  loading: () {
                    // the reason behind using listview to dont show continous loading and show the previous tweets
                    return ListView.builder(
                      itemCount: tweets.length,
                      itemBuilder: (context, index) {
                        final tweet = tweets[index];
                        return TweetCard(tweet: tweet);
                      },
                    );
                  },
                );
            // return ListView.builder(
            //   itemCount: tweets.length,
            //   itemBuilder: (context, index) {
            //     final tweet = tweets[index];
            //     return TweetCard(tweet: tweet);
            //   },
            // );
          },
          error: (error, stacktrace) => ErrorPage(errorText: error.toString()),
          loading: () => const Loader(),
        );
  }
}
