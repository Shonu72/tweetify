import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:riverpod/riverpod.dart';
import 'package:tweetify/constants/constants.dart';
import 'package:tweetify/core/core.dart';
import 'package:tweetify/core/providers.dart';
import 'package:tweetify/models/user_models.dart';
import 'package:fpdart/fpdart.dart';

final userAPIProvider = Provider((ref) {
  final db = ref.watch(appWriteDatabaseProvider);
  final realtime = ref.watch(appWriteRealtimeProvider);
  return UserAPI(db: db, realmtime: realtime);
});

abstract class IUserAPI {
  FutureEitherVoid saveUserData(UserModel userModel);
  Future<Document> getUserData(String uid);
  Future<List<Document>> searchUserByName(String name);
  FutureEitherVoid updateUserData(UserModel userModel);
  Stream<RealtimeMessage> getLatestProfileData();
}

class UserAPI implements IUserAPI {
  final Databases _db;
  final Realtime _realtime;

  UserAPI({
    required Databases db,
    required Realtime realmtime,
  })  : _db = db,
        _realtime = realmtime;
  @override
  FutureEitherVoid saveUserData(UserModel userModel) async {
    try {
      await _db.createDocument(
        databaseId: AppWriteConstant.databaseId,
        collectionId: AppWriteConstant.userCollectionId,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(Failure(e.message ?? 'Something went wrong', st));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<Document> getUserData(String uid) {
    return _db.getDocument(
      databaseId: AppWriteConstant.databaseId,
      collectionId: AppWriteConstant.userCollectionId,
      documentId: uid,
    );
  }

  @override
  Future<List<Document>> searchUserByName(String name) async {
    final documents = await _db.listDocuments(
      databaseId: AppWriteConstant.databaseId,
      collectionId: AppWriteConstant.userCollectionId,
      queries: [
        Query.search('name', name),
      ],
    );
    return documents.documents;
  }

  @override
  FutureEitherVoid updateUserData(UserModel userModel) async {
    try {
      await _db.updateDocument(
        databaseId: AppWriteConstant.databaseId,
        collectionId: AppWriteConstant.userCollectionId,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(Failure(e.message ?? 'Something went wrong', st));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Stream<RealtimeMessage> getLatestProfileData() {
    return _realtime.subscribe([
      'databases.${AppWriteConstant.databaseId}.collections.${AppWriteConstant.userCollectionId}.documents',
    ]).stream;
  }
}
