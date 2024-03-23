import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tweetify/features/auth/controller/auth_controller.dart';
import 'package:tweetify/features/profile/controller/user_profile_controller.dart';
import 'package:tweetify/features/profile/views/user_profile_view.dart';

class SideDrawer extends ConsumerWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDeailsProvider).value;
    return SafeArea(
      child: Column(
        children: [
          // CircleAvatar(
          //   radius: 50,
          //   backgroundImage: ,

          // ),
          const SizedBox(
            height: 50,
          ),
          ListTile(
            leading: const Icon(
              Icons.person,
              size: 30,
            ),
            title: const Text(
              'My Profile',
              style: TextStyle(
                fontSize: 22,
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
                fontSize: 22,
              ),
            ),
            onTap: () {
              ref
                  .read(userProfileControllerProvider.notifier)
                  .updateUserProfile(
                      userModel: currentUser!.copyWith(
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
                fontSize: 22,
              ),
            ),
            onTap: () {
              ref.read(authControllerProvider.notifier).logout(context);
            },
          ),
        ],
      ),
    );
  }
}
