import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod/riverpod.dart';

import 'package:tweetify/constants/appwrite_constant.dart';
import 'package:tweetify/core/core.dart';
import 'package:tweetify/core/providers.dart';
import 'package:tweetify/models/notification_model.dart';

final notificatioApiProvider = Provider((ref) {
  return NotificationAPI(
    db: ref.watch(appWriteDatabaseProvider),
    realtime: ref.watch(appWriteRealtimeProvider),
  );
});

abstract class INotificationAPI {
  FutureEitherVoid createNotification(Notification notification);
  Future<List<Document>> getNotifications(String uid);
  Stream<RealtimeMessage> getLatestNotifications();
}

class NotificationAPI implements INotificationAPI {
  final Databases _db;
  final Realtime _realtime;
  NotificationAPI({required Databases db, required Realtime realtime})
      : _realtime = realtime,
        _db = db;


  @override
  FutureEitherVoid createNotification(Notification notification) async {
    try {
      await _db.createDocument(
        databaseId: AppWriteConstant.databaseId,
        collectionId: AppWriteConstant.notificationCollectionId,
        documentId: ID.unique(),
        data: notification.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<List<Document>> getNotifications(String uid) async {
    final documents = await _db.listDocuments(
      databaseId: AppWriteConstant.databaseId,
      collectionId: AppWriteConstant.notificationCollectionId,
      queries: [
        Query.equal('uid', uid),
      ],
    );
    return documents.documents;
  }

   @override
  Stream<RealtimeMessage> getLatestNotifications() {
    return _realtime.subscribe([
      // this will go to the collection and listen for the changes
      'databases.${AppWriteConstant.databaseId}.collections.${AppWriteConstant.notificationCollectionId}.documents',
    ]).stream;
  }
}
