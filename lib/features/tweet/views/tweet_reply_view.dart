import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tweetify/common/error_page.dart';
import 'package:tweetify/common/loading_page.dart';
import 'package:tweetify/constants/appwrite_constant.dart';
import 'package:tweetify/features/tweet/controller/tweet_controller.dart';

import 'package:tweetify/features/tweet/widgets/tweet_card.dart';
import 'package:tweetify/models/tweet_model.dart';

class TweetReplyScreen extends ConsumerWidget {
  static route(Tweet tweet) =>
      MaterialPageRoute(builder: (context) => TweetReplyScreen(tweet: tweet));
  final Tweet tweet;
  const TweetReplyScreen({
    super.key,
    required this.tweet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Post'),
        ),
        body: Column(
          children: [
            TweetCard(tweet: tweet),
            ref.watch(getRepliesToTweetProvider(tweet)).when(
                  data: (tweets) {
                    return ref.watch(getLatestTweetProvider).when(
                          data: (data) {
                            // print(data);
                            final latestTweet = Tweet.fromMap(data.payload);
                            bool isTweetAlreadyPresent = false;
                            for (final tweetModel in tweets) {
                              if (tweetModel.id == latestTweet.id) {
                                isTweetAlreadyPresent = true;
                                break;
                              }
                            }
                            if (!isTweetAlreadyPresent &&
                                latestTweet.repliedTo == tweet.id) {
                              if (data.events.contains(
                                  // this will listen to any changes in the collection and * is used for all the documents but its not a good practice
                                  // need to make new database for production
                                  'databases.*.collections.${AppWriteConstant.tweetCollectionId}.documents.*.create')) {
                                print(data.events);
                                tweets.insert(0, Tweet.fromMap(data.payload));
                              } else if (data.events.contains(
                                  'databases.*.collections.${AppWriteConstant.tweetCollectionId}.documents.*.update')) {
                                // get id of tweet
                                final startingPoint =
                                    data.events[0].lastIndexOf('documents.');
                                final endPoint =
                                    data.events[0].lastIndexOf('.update');
                                final tweetId = data.events[0]
                                    .substring(startingPoint + 10, endPoint);

                                var tweet = tweets
                                    .where((element) => element.id == tweetId)
                                    .first;

                                final tweetIndex = tweets.indexOf(tweet);
                                tweets.removeWhere(
                                    (element) => element.id == tweetId);

                                tweet = Tweet.fromMap(data.payload);
                                tweets.insert(tweetIndex, tweet);
                              }
                            }
                            return Expanded(
                              child: ListView.builder(
                                itemCount: tweets.length,
                                itemBuilder: (context, index) {
                                  final tweet = tweets[index];
                                  return TweetCard(tweet: tweet);
                                },
                              ),
                            );
                          },
                          error: (error, stacktrace) =>
                              ErrorPage(errorText: error.toString()),
                          loading: () {
                            // the reason behind using listview to dont show continous loading and show the previous tweets
                            return Expanded(
                              child: ListView.builder(
                                itemCount: tweets.length,
                                itemBuilder: (context, index) {
                                  final tweet = tweets[index];
                                  return TweetCard(tweet: tweet);
                                },
                              ),
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
                  error: (error, stacktrace) =>
                      ErrorPage(errorText: error.toString()),
                  loading: () => const Loader(),
                )
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                TextField(
                  onSubmitted: (value) {
                    // can add images and other media in reply like real twitter
                    ref.read(tweetControllerProvider.notifier).shareTweet(
                      images: [],
                      text: value,
                      context: context,
                      repliedTo: tweet.id,
                    );
                  },
                  decoration: const InputDecoration(
                    hintText: 'Tweet your reply',
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ));
  }
}
