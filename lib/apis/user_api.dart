import 'package:appwrite/appwrite.dart';
import 'package:riverpod/riverpod.dart';
import 'package:tweetify/constants/constants.dart';
import 'package:tweetify/core/core.dart';
import 'package:tweetify/core/providers.dart';
import 'package:tweetify/models/user_models.dart';
import 'package:fpdart/fpdart.dart';

final userAPIProvider = Provider((ref) {
  final db = ref.watch(appWriteDatabaseProvider);
  return UserAPI(db: db);
});


abstract class IUserAPI {
  FutureEitherVoid saveUserData(UserModel userModel);
}

class UserAPI implements IUserAPI {
  final Databases _db;
  UserAPI({required Databases db}) : _db = db;
  @override
  FutureEitherVoid saveUserData(UserModel userModel) async {
    try {
      await _db.createDocument(
        databaseId: AppWriteConstant.databaseId,
        collectionId: AppWriteConstant.userCollectionId,
        documentId: ID.unique(),
        data: userModel.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(Failure(e.message ?? 'Something went wrong', st));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }
}
