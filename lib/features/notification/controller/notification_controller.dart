import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tweetify/apis/notification_api.dart';
import 'package:tweetify/core/enums/notification_type_enum.dart';
import 'package:tweetify/models/notification_model.dart';

final notoficationControllerProvider =
    StateNotifierProvider<NotoficationController, bool>((ref) {
  return NotoficationController(
    notificationAPI: ref.watch(notificatioApiProvider),
  );
});

final getLatestNotificationProvider = StreamProvider((ref) {
  final notificationAPI = ref.watch(notificatioApiProvider);
  return notificationAPI.getLatestNotifications();
});

final getNotificationsProvider = FutureProvider.family((ref, String uid) async {
  final notificationController = ref.watch(notoficationControllerProvider.notifier);
  return notificationController.getNotifications(uid);
});

class NotoficationController extends StateNotifier<bool> {
  final NotificationAPI _notificationAPI;
  NotoficationController({
    required NotificationAPI notificationAPI,
  })  : _notificationAPI = notificationAPI,
        super(false);

  void createNotificatio({
    required String text,
    required String postId,
    required String uid,
    required NotificationType notificationType,
  }) async {
    final notification = Notification(
      text: text,
      postId: postId,
      id: '',
      uid: uid,
      notificationType: notificationType,
    );
    final res = await _notificationAPI.createNotification(notification);
    res.fold((l) => print(l.message), (r) => null);
  }

  Future<List<Notification>> getNotifications(String uid) async {
    final notifications = await _notificationAPI.getNotifications(uid);
    return notifications.map((e) => Notification.fromMap(e.data)).toList();
  }
}
