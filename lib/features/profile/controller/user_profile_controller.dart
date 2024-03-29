import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tweetify/apis/storage_api.dart';
import 'package:tweetify/apis/tweet_api.dart';
import 'package:tweetify/apis/user_api.dart';
import 'package:tweetify/core/enums/notification_type_enum.dart';
import 'package:tweetify/core/utils.dart';
import 'package:tweetify/features/notification/controller/notification_controller.dart';
import 'package:tweetify/models/tweet_model.dart';
import 'package:tweetify/models/user_models.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  return UserProfileController(
    tweetAPI: ref.watch(tweetAPIProvider),
    storageAPI: ref.watch(storageAPIProvider),
    userApi: ref.watch(userAPIProvider),
    notoficationController: ref.watch(notoficationControllerProvider.notifier),
  );
});

final getUserTweetsProvider = FutureProvider.family((ref, String uid) async {
  final userProfileController =
      ref.watch(userProfileControllerProvider.notifier);
  return userProfileController.getUserTweets(uid);
});

final getLatestUserProfileDataProvider = StreamProvider((ref) {
  final userApi = ref.watch(userAPIProvider);
  return userApi.getLatestProfileData();
});

class UserProfileController extends StateNotifier<bool> {
  final TweetAPI _tweetAPI;
  final StorageAPI _storageAPI;
  final UserAPI _userApi;
  final NotoficationController _notificationController;

  UserProfileController({
    required TweetAPI tweetAPI,
    required StorageAPI storageAPI,
    required UserAPI userApi,
    required NotoficationController notoficationController,
  })  : _tweetAPI = tweetAPI,
        _storageAPI = storageAPI,
        _userApi = userApi,
        _notificationController = notoficationController,
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

  void followUser({
    required UserModel user,
    required BuildContext context,
    required UserModel currentUser,
  }) async {
    // this means already following the user
    if (currentUser.following.contains(user.uid)) {
      user.followers.remove(currentUser.uid);
      currentUser.following.remove(user.uid);
    } else {
      // add the user to the following list
      user.followers.add(currentUser.uid);
      currentUser.following.add(user.uid);
    }
    user = user.copyWith(followers: user.followers);
    currentUser = currentUser.copyWith(
      following: currentUser.following,
    );

    final res = await _userApi.followUser(user);
    res.fold((l) => showSnackBar(context, l.message), (r) async {
      final res2 = await _userApi.addToFollowing(currentUser);
      res2.fold((l) => showSnackBar(context, l.message), (r) {
        _notificationController.createNotificatio(
          text: '${currentUser.name} follwed you',
          postId: '',
          uid: user.uid,
          notificationType: NotificationType.follow,
        );
      });
    });
  }
}
