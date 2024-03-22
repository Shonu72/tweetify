import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tweetify/common/common.dart';
import 'package:tweetify/common/error_page.dart';
import 'package:tweetify/constants/constants.dart';
import 'package:tweetify/features/auth/controller/auth_controller.dart';
import 'package:tweetify/features/profile/controller/user_profile_controller.dart';
import 'package:tweetify/features/profile/views/user_edit_view.dart';
import 'package:tweetify/features/profile/widgets/follow_count.dart';
import 'package:tweetify/features/tweet/controller/tweet_controller.dart';
import 'package:tweetify/features/tweet/widgets/tweet_card.dart';
import 'package:tweetify/models/tweet_model.dart';
import 'package:tweetify/models/user_models.dart';
import 'package:tweetify/theme/pallete.dart';

class UserProfile extends ConsumerWidget {
  final UserModel user;
  const UserProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDeailsProvider).value;

    return currentUser == null
        ? const Loader()
        : NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 150,
                  floating: true,
                  snap: true,
                  flexibleSpace: Stack(
                    children: [
                      Positioned.fill(
                        child: user.bannerPic.isEmpty
                            ? Container(
                                color: Pallete.blueColor,
                              )
                            : Image.network(user.bannerPic, fit: BoxFit.fitWidth),
                      ),
                      Positioned(
                        bottom: 2,
                        left: 5,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(user.profilePic),
                          radius: 45,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(20),
                        alignment: Alignment.bottomRight,
                        child: OutlinedButton(
                            onPressed: () {
                              if (currentUser.uid == user.uid) {
                                Navigator.push(
                                    context, EditProfileView.route());
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: const BorderSide(
                                      color: Pallete.whiteColor)),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                            ),
                            child: Text(
                              currentUser.uid == user.uid
                                  ? 'Edit Profile'
                                  : "Follow",
                              style: const TextStyle(
                                color: Pallete.whiteColor,
                              ),
                            )),
                      )
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(8),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        '@${user.name}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Pallete.greyColor,
                        ),
                      ),
                      Text(
                        user.bio,
                        style: const TextStyle(
                          color: Pallete.whiteColor,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          FollowCount(
                              count: user.following.length,
                              text: " Followings"),
                          const SizedBox(
                            width: 15,
                          ),
                          FollowCount(
                              count: user.followers.length, text: " Followers")
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Divider(
                        color: Pallete.greyColor,
                      ),
                    ]),
                  ),
                )
              ];
            },
            body: ref.watch(getUserTweetsProvider(user.uid)).when(
                data: (tweets) {
                  return ref.watch(getLatestTweetProvider).when(
                        data: (data) {
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
                },
                error: (error, st) => ErrorPage(errorText: error.toString()),
                loading: () => const Loader()));
  }
}
