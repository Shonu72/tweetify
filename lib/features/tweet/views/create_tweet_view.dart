import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:tweetify/common/common.dart';
import 'package:tweetify/constants/assets_constant.dart';
import 'package:tweetify/core/utils.dart';
import 'package:tweetify/features/auth/controller/auth_controller.dart';
import 'package:tweetify/features/tweet/controller/tweet_controller.dart';
import 'package:tweetify/theme/pallete.dart';

class CreateTweetScreen extends ConsumerStatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const CreateTweetScreen());

  const CreateTweetScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateTweetScreenState();
}

class _CreateTweetScreenState extends ConsumerState<CreateTweetScreen> {
  final tweetTextController = TextEditingController();
  List<File> images = [];
  @override
  void dispose() {
    tweetTextController.dispose();
    super.dispose();
  }

  void shareTweet() {
    ref.read(tweetControllerProvider.notifier).shareTweet(
          images: images,
          text: tweetTextController.text,
          context: context, repliedTo: '',
        );
    Navigator.pop(context);
  }

  void onPickImages() async {
    images = await pickImages();
    setState(
      () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDeailsProvider).value;
    print(currentUser);
    final isLoading = ref.watch(tweetControllerProvider);
    print(isLoading.toString());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 10,
              top: 8,
            ),
            child: RoundedSmallButton(
              onTap: shareTweet,
              label: "Tweet",
              backgroundColor: Pallete.blueColor,
              textColor: Pallete.whiteColor,
            ),
          )
        ],
      ),
      body: isLoading || currentUser == null
          ? const Loader()
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(currentUser.profilePic),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextField(
                            controller: tweetTextController,
                            style: const TextStyle(
                              fontSize: 22,
                            ),
                            decoration: const InputDecoration(
                              hintText: "What's happening ?",
                              hintStyle: TextStyle(
                                color: Pallete.greyColor,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                              border: InputBorder.none,
                            ),
                            maxLines: null,
                          ),
                        ),
                      ],
                    ),
                    if (images.isNotEmpty)
                      CarouselSlider(
                        items: images.map(
                          (file) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              child: Image.file(file),
                            );
                          },
                        ).toList(),
                        options: CarouselOptions(
                          height: 400,
                          enableInfiniteScroll: false,
                        ),
                      ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 15),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Pallete.greyColor, width: 0.3),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(left: 15, right: 15),
              child: GestureDetector(
                onTap: onPickImages,
                child: SvgPicture.asset(
                  AssetsConstants.galleryIcon,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(left: 15, right: 15),
              child: SvgPicture.asset(AssetsConstants.gifIcon),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(left: 15, right: 15),
              child: SvgPicture.asset(AssetsConstants.emojiIcon),
            ),
          ],
        ),
      ),
    );
  }
}
