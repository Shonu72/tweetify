import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tweetify/common/common.dart';
import 'package:tweetify/core/utils.dart';
import 'package:tweetify/features/auth/controller/auth_controller.dart';
import 'package:tweetify/features/profile/controller/user_profile_controller.dart';
import 'package:tweetify/theme/pallete.dart';

class EditProfileView extends ConsumerStatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const EditProfileView());
  const EditProfileView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  late TextEditingController nameController;
  late TextEditingController bioController;
  File? bannerImage;
  File? profileImage;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
        text: ref.read(currentUserDeailsProvider).value?.name ?? '');
    bioController = TextEditingController(
        text: ref.read(currentUserDeailsProvider).value?.bio ?? '');
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    bioController.dispose();
  }

  void selectBannerImage() async {
    final banner = await pickImage();
    if (banner != null) {
      setState(() {
        bannerImage = banner;
      });
    }
  }

  void selectProfileImage() async {
    final profile = await pickImage();
    if (profile != null) {
      setState(() {
        profileImage = profile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    final user = ref.watch(currentUserDeailsProvider).value;
    return user == null
        ? const Loader()
        : Scaffold(
            appBar: AppBar(
              title: const Text("Edit Profile"),
              actions: [
                TextButton(
                    onPressed: () {
                      ref
                          .read(userProfileControllerProvider.notifier)
                          .updateUserProfile(
                              userModel: user.copyWith(
                                  name: nameController.text,
                                  bio: bioController.text),
                              context: context,
                              bannerImage: bannerImage,
                              profileImage: profileImage);
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(
                        color: Pallete.blueColor,
                      ),
                    )),
              ],
            ),
            body: isLoading || user == null
                ? const Loader()
                : Column(
                    children: [
                      SizedBox(
                        height: 200,
                        child: Stack(children: [
                          GestureDetector(
                            onTap: selectBannerImage,
                            child: Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  // color: Pallete.blueColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: bannerImage != null
                                  ? Image.file(bannerImage!,
                                      fit: BoxFit.fitWidth)
                                  : user.bannerPic.isEmpty
                                      ? Container(
                                          color: Pallete.blueColor,
                                        )
                                      : Image.network(
                                          user.bannerPic,
                                          fit: BoxFit.fitWidth,
                                        ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 10,
                            child: GestureDetector(
                              onTap: selectProfileImage,
                              child: profileImage != null
                                  ? CircleAvatar(
                                      backgroundImage: FileImage(profileImage!),
                                      radius: 40,
                                    )
                                  : CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(user.profilePic),
                                      radius: 40,
                                    ),
                            ),
                          ),
                        ]),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Pallete.blueColor),
                            ),
                            contentPadding: EdgeInsets.all(18),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: bioController,
                          decoration: const InputDecoration(
                            labelText: 'Bio',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Pallete.blueColor),
                            ),
                            contentPadding: EdgeInsets.all(18),
                          ),
                          maxLines: 3,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      )
                    ],
                  ),
          );
  }
}
