import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tweetify/apis/storage_api.dart';
import 'package:tweetify/apis/tweet_api.dart';
import 'package:tweetify/core/enums/tweet_type_enum.dart';
import 'package:tweetify/core/utils.dart';
import 'package:tweetify/features/auth/controller/auth_controller.dart';
import 'package:tweetify/models/tweet_model.dart';
import 'package:tweetify/models/user_models.dart';

final tweetControllerProvider =
    StateNotifierProvider<TweetController, bool>((ref) {
  return TweetController(
    ref: ref,
    tweetAPI: ref.watch(tweetAPIProvider),
    storageAPI: ref.watch(storageAPIProvider),
  );
});

final getTweetsProvider = FutureProvider((ref) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweets();
});

// autodispose dispose the provider automatically , good practice to put in evry provider
final getLatestTweetProvider = StreamProvider.autoDispose((ref) {
  final tweetAPI = ref.watch(tweetAPIProvider);
  return tweetAPI.getLatestTweets();
});

class TweetController extends StateNotifier<bool> {
  final TweetAPI _tweetAPI;
  final Ref _ref;
  final StorageAPI _storageAPI;

  TweetController(
      {required Ref ref,
      required TweetAPI tweetAPI,
      required StorageAPI storageAPI})
      : _ref = ref,
        _tweetAPI = tweetAPI,
        _storageAPI = storageAPI,
        super(false);

  Future<List<Tweet>> getTweets() async {
    final tweetList = await _tweetAPI.getTweets();
    return tweetList.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }

  void likeTweet(Tweet tweet, UserModel user) async {
    List<String> likes = tweet.likes;
    if (tweet.likes.contains(user.uid)) {
      likes.remove(user.uid);
    } else {
      likes.add(user.uid);
    }

    tweet = tweet.copyWith(likes: likes);
    final res = await _tweetAPI.likeTweet(tweet);
    res.fold((l) => null, (r) => null);
  }

  void shareTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
  }) {
    if (text.isEmpty) {
      showSnackBar(context, "Please enter text");
    } else if (images.isNotEmpty) {
      // for image tweet
      _shareImageTweet(
        images: images,
        text: text,
        context: context,
      );
    } else {
      // for only text tweet
      _shareTextTweet(
        text: text,
        context: context,
      );
    }
  }

  void reshareTweet(
      Tweet tweet, UserModel currentUser, BuildContext context) async {
    tweet = tweet.copyWith(
      retweetedBy: currentUser.name,
      likes: [],
      commentIds: [],
      reshareCount: tweet.reshareCount + 1,
    );
    final res = await _tweetAPI.updateReshareCount(tweet);
    res.fold((l) => showSnackBar(context, l.message), (r) async {
      tweet = tweet.copyWith(
        id: ID.unique(),
        reshareCount: 0,
      );
      final res2 = await _tweetAPI.shareTweet(tweet);
      res2.fold((l) => showSnackBar(context, l.message),
          (r) => showSnackBar(context, "Retweeted"));
    });
  }

  void _shareImageTweet({
    //private function for only text tweet
    required List<File> images,
    required String text,
    required BuildContext context,
  }) async {
    state = true;
    final hashtags = _getHashTagFromText(text);
    String link = _getLinkFromText(text);
    final user = _ref.read(currentUserDeailsProvider).value!;
    final imageLinks = await _storageAPI.uploadImage(images);
    Tweet tweet = Tweet(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: imageLinks,
      uid: user.uid,
      tweetType: TweetType.image,
      tweetedAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      id: '',
      reshareCount: 0,
      retweetedBy: '',
    );
    final res = await _tweetAPI.shareTweet(tweet);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  void _shareTextTweet({
    //private function for only text tweet
    required String text,
    required BuildContext context,
  }) async {
    state = true;
    final hashtags = _getHashTagFromText(text);
    String link = _getLinkFromText(text);
    final user = _ref.read(currentUserDeailsProvider).value!;
    Tweet tweet = Tweet(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: const [],
      uid: user.uid,
      tweetType: TweetType.text,
      tweetedAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      id: '',
      reshareCount: 0,
      retweetedBy: '',
    );
    final res = await _tweetAPI.shareTweet(tweet);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  String _getLinkFromText(String text) {
    // private function for getting link from text
    String link = '';
    List<String> wordsInSentences = text.split(" ");
    for (String word in wordsInSentences) {
      if (word.startsWith("http") ||
          word.startsWith("https") ||
          word.startsWith("www")) {
        link = word;
      }
    }
    return link;
  }

  List<String> _getHashTagFromText(String text) {
    // private function for getting hashtag from text
    List<String> hashtag = [];
    List<String> wordsInSentences = text.split(" ");
    for (String word in wordsInSentences) {
      if (word.startsWith("#")) {
        hashtag.add(word);
      }
    }
    return hashtag;
  }
}
