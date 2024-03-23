import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tweetify/common/common.dart';
import 'package:tweetify/common/error_page.dart';
import 'package:tweetify/constants/appwrite_constant.dart';
import 'package:tweetify/features/auth/controller/auth_controller.dart';
import 'package:tweetify/features/notification/controller/notification_controller.dart';
import 'package:tweetify/features/notification/views/notification_tile.dart';
import 'package:tweetify/models/notification_model.dart' as notification_model;

class NotificationView extends ConsumerWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDeailsProvider).value;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
      ),
      body: currentUser == null
          ? const Loader()
          : ref.watch(getNotificationsProvider(currentUser.uid)).when(
                data: (notifications) {
                  return ref.watch(getLatestNotificationProvider).when(
                        data: (data) {
                          // print(data);

                          if (data.events.contains(
                              'databases.*.collections.${AppWriteConstant.notificationCollectionId}.documents.*.create')) {
                            // print(data.events);
                            final latestNotif =
                                notification_model.Notification.fromMap(
                                    data.payload);
                            if (latestNotif.uid == currentUser.uid) {
                              notifications.insert(0, latestNotif);
                            }
                          }

                          return ListView.builder(
                            itemCount: notifications.length,
                            itemBuilder: (context, index) {
                              final notification = notifications[index];
                              return NotificationTile(
                                  notification: notification);
                            },
                          );
                        },
                        error: (error, stacktrace) =>
                            ErrorPage(errorText: error.toString()),
                        loading: () {
                          // the reason behind using listview to dont show continous loading and show the previous tweets
                          return ListView.builder(
                            itemCount: notifications.length,
                            itemBuilder: (context, index) {
                              final notification = notifications[index];
                              return NotificationTile(
                                  notification: notification);
                            },
                          );
                        },
                      );
                  // return ListView.builder(
                  //   itemCount: tweets.length,
                  //   itemBuilder: (context, index) {
                  //     final tweet = tweets[index];
                  //     return TweetCard(tweet: tweet);
                  //   },
                  // );
                },
                error: (error, stacktrace) =>
                    ErrorPage(errorText: error.toString()),
                loading: () => const Loader(),
              ),
    );
  }
}
