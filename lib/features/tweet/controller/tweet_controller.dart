import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tweetify/apis/tweet_api.dart';
import 'package:tweetify/core/enums/tweet_type_enum.dart';
import 'package:tweetify/core/utils.dart';
import 'package:tweetify/features/auth/controller/auth_controller.dart';
import 'package:tweetify/models/tweet_model.dart';

final tweetControllerProvider =
    StateNotifierProvider<TweetController, bool>((ref) {
  return TweetController(
    ref: ref,
    tweetAPI: ref.watch(tweetAPIProvider),
  );
});

class TweetController extends StateNotifier<bool> {
  final TweetAPI _tweetAPI;
  final Ref _ref;

  TweetController({required Ref ref, required TweetAPI tweetAPI})
      : _ref = ref,
        _tweetAPI = tweetAPI,
        super(false);

  void shareTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
  }) {
    if (text.isEmpty) {
      showSnackBar(context, "Please enter text");
    }

    if (text.isNotEmpty) {
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

  void _shareImageTweet({
    //private function for only text tweet
    required List<File> images,
    required String text,
    required BuildContext context,
  }) async{
    state = true;
    final hashtags = _getHashTagFromText(text);
    String link = _getLinkFromText(text);
    final user = _ref.read(currentUserDeailsProvider).value!;
    Tweet tweet = Tweet(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: [],
      uid: user.uid,
      tweetType: TweetType.image,
      tweetedAt: DateTime.now(),
      likes: [],
      commentIds: [],
      id: '',
      reshareCount: 0,
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
      imageLinks: [],
      uid: user.uid,
      tweetType: TweetType.text,
      tweetedAt: DateTime.now(),
      likes: [],
      commentIds: [],
      id: '',
      reshareCount: 0,
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
