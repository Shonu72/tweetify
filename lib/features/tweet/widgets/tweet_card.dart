import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tweetify/common/common.dart';
import 'package:tweetify/common/error_page.dart';
import 'package:tweetify/constants/constants.dart';
import 'package:tweetify/core/enums/tweet_type_enum.dart';
import 'package:tweetify/features/auth/controller/auth_controller.dart';
import 'package:tweetify/features/tweet/widgets/carousel_image.dart';
import 'package:tweetify/features/tweet/widgets/hashtags_text.dart';
import 'package:tweetify/features/tweet/widgets/tweet_icon_buttons.dart';
import 'package:tweetify/models/tweet_model.dart';
import 'package:tweetify/theme/pallete.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:any_link_preview/any_link_preview.dart';

class TweetCard extends ConsumerWidget {
  final Tweet tweet;
  const TweetCard({super.key, required this.tweet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userDetailsProvider(tweet.uid)).when(
          data: (user) {
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: CircleAvatar(
                        // will show different profile pic for different users
                        backgroundImage: NetworkImage(user.profilePic),
                        radius: 30,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // retweet
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 5),
                                child: Text(
                                  user.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Text(
                                '@${user.name} . ${timeago.format(tweet.tweetedAt, locale: 'en_short')}',
                                style: const TextStyle(
                                  color: Pallete.greyColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          // replied to
                          HashTagText(text: tweet.text),
                          if (tweet.tweetType == TweetType.image)
                            CarouselImage(imageLinks: tweet.imageLinks),
                          if (tweet.link.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            AnyLinkPreview(
                              displayDirection:
                                  UIDirection.uiDirectionHorizontal,
                              link: 'https://${tweet.link}',
                            ),
                          ],
                          Container(
                            margin: const EdgeInsets.only(right: 20, top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TweetIconButton(
                                  pathName: AssetsConstants.viewsIcon,
                                  text: (tweet.commentIds.length +
                                          tweet.reshareCount +
                                          tweet.likes.length)
                                      .toString(),
                                  onTap: () {},
                                ),
                                TweetIconButton(
                                  pathName: AssetsConstants.commentIcon,
                                  text: tweet.commentIds.length.toString(),
                                  onTap: () {},
                                ),
                                TweetIconButton(
                                  pathName: AssetsConstants.retweetIcon,
                                  text: tweet.reshareCount.toString(),
                                  onTap: () {},
                                ),
                                TweetIconButton(
                                  pathName: AssetsConstants.likeOutlinedIcon,
                                  text: tweet.likes.length.toString(),
                                  onTap: () {},
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.share,
                                      size: 25,
                                      color: Pallete.greyColor,
                                    ))
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 1,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Pallete.greyColor,
                  thickness: 0.5,
                )
              ],
            );
          },
          error: ((error, stackTrace) =>
              ErrorPage(errorText: error.toString())),
          loading: () => const Loader(),
        );
  }
}