import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tweetify/features/auth/controller/auth_controller.dart';
import 'package:tweetify/features/profile/controller/user_profile_controller.dart';
import 'package:tweetify/features/profile/views/user_profile_view.dart';
import 'package:tweetify/theme/pallete.dart';

class SideDrawer extends ConsumerWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDeailsProvider).value;
    return SafeArea(
      child: Drawer(
        backgroundColor: Pallete.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                // radius: 50,
                backgroundImage: NetworkImage(
                  currentUser!.profilePic,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                currentUser.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '@${currentUser.name}',
                style: const TextStyle(fontSize: 16, color: Pallete.greyColor),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    currentUser.following.length.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Pallete.whiteColor,
                    ),
                  ),
                  const Text(
                    ' Following',
                    style: TextStyle(fontSize: 16, color: Pallete.greyColor),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    currentUser.followers.length.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Pallete.whiteColor,
                    ),
                  ),
                  const Text(
                    ' Followers',
                    style: TextStyle(fontSize: 16, color: Pallete.greyColor),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              const Divider(
                color: Pallete.greyColor,
                thickness: 0.5,
              ),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                leading: const Icon(
                  Icons.person,
                  size: 30,
                ),
                title: const Text(
                  'My Profile',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  Navigator.push(context, UserProfileView.route(currentUser!));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.payments,
                  size: 30,
                ),
                title: const Text(
                  'Twitter Blue',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  ref
                      .read(userProfileControllerProvider.notifier)
                      .updateUserProfile(
                          userModel: currentUser.copyWith(
                            isTwitterBlue: true,
                          ),
                          context: context,
                          bannerImage: null,
                          profileImage: null);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  size: 30,
                ),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  ref.read(authControllerProvider.notifier).logout(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
