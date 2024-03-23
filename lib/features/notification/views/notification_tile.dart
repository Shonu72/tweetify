import 'package:flutter/material.dart';
import 'package:tweetify/constants/assets_constant.dart';
import 'package:tweetify/core/enums/notification_type_enum.dart';
import 'package:tweetify/models/notification_model.dart' as notification_model;
import 'package:tweetify/theme/pallete.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationTile extends StatelessWidget {
  final notification_model.Notification notification;
  const NotificationTile({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: notification.notificationType == NotificationType.follow
          ? const Icon(
              Icons.person,
              color: Pallete.blueColor,
            )
          : notification.notificationType == NotificationType.reply
              ? const Icon(
                  Icons.comment,
                  color: Pallete.blueColor,
                )
              : notification.notificationType == NotificationType.like
                  ? SvgPicture.asset(
                      AssetsConstants.likeFilledIcon,
                      color: Pallete.redColor,
                      height: 20,
                    )
                  : notification.notificationType == NotificationType.retweet
                      ? SvgPicture.asset(
                          AssetsConstants.retweetIcon,
                          color: Pallete.whiteColor,
                          height: 20,
                        )
                      : null,
      title: Text(notification.text),
    );
  }
}
