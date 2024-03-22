import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tweetify/apis/storage_api.dart';
import 'package:tweetify/apis/tweet_api.dart';
import 'package:tweetify/apis/user_api.dart';
import 'package:tweetify/core/utils.dart';
import 'package:tweetify/models/tweet_model.dart';
import 'package:tweetify/models/user_models.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  return UserProfileController(
    tweetAPI: ref.watch(tweetAPIProvider),
    storageAPI: ref.watch(storageAPIProvider),
    userApi: ref.watch(userAPIProvider),
  );
});

final getUserTweetsProvider = FutureProvider.family((ref, String uid) async {
  final userProfileController =
      ref.watch(userProfileControllerProvider.notifier);
  return userProfileController.getUserTweets(uid);
});

final getLatestUserProfileDataProvider = StreamProvider((ref){
  final userApi = ref.watch(userAPIProvider);
  return userApi.getLatestProfileData();
});

class UserProfileController extends StateNotifier<bool> {
  final TweetAPI _tweetAPI;
  final StorageAPI _storageAPI;
  final UserAPI _userApi;
  UserProfileController({
    required TweetAPI tweetAPI,
    required StorageAPI storageAPI,
    required UserAPI userApi,
  })  : _tweetAPI = tweetAPI,
        _storageAPI = storageAPI,
        _userApi = userApi,
        super(false);

  Future<List<Tweet>> getUserTweets(String uid) async {
    final tweets = await _tweetAPI.getUserTweets(uid);
    return tweets.map((e) => Tweet.fromMap(e.data)).toList();
  }

  void updateUserProfile(
      {required UserModel userModel,
      required BuildContext context,
      required File? bannerImage,
      required File? profileImage}) async {
    state = true;
    if (bannerImage != null) {
      final bannerImageUrl = await _storageAPI.uploadImage([bannerImage]);
      userModel = userModel.copyWith(bannerPic: bannerImageUrl[0]);
    }

    if (profileImage != null) {
      final profileImageUrl = await _storageAPI.uploadImage([profileImage]);
      userModel = userModel.copyWith(profilePic: profileImageUrl[0]);
    }

    final res = await _userApi.updateUserData(userModel);
    state = false;
    res.fold(
        (l) => showSnackBar(context, l.message), (r) => Navigator.pop(context));
  }
}
