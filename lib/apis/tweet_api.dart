import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:riverpod/riverpod.dart';
import 'package:tweetify/constants/appwrite_constant.dart';
import 'package:tweetify/core/core.dart';
import 'package:tweetify/core/providers.dart';
import 'package:tweetify/core/type_defs.dart';
import 'package:tweetify/models/tweet_model.dart';
import 'package:fpdart/fpdart.dart';

final tweetAPIProvider = Provider((ref) {
  return TweetAPI(
    db: ref.watch(
      appWriteDatabaseProvider,
    ),
  );
});

abstract class ITweetAPI {
  FutureEither<Document> shareTweet(Tweet tweet);
  Future<List<Document>> getTweets();
}

class TweetAPI implements ITweetAPI {
  final Databases _db;
  TweetAPI({required Databases db}) : _db = db;
  @override
  FutureEither<Document> shareTweet(Tweet tweet) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppWriteConstant.databaseId,
        collectionId: AppWriteConstant.tweetCollectionId,
        documentId: ID.unique(),
        data: tweet.toMap(),
      );
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(Failure(e.message ?? 'Something went wrong', st));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<List<Document>> getTweets() async {
    final documents = await _db.listDocuments(
      databaseId: AppWriteConstant.databaseId,
      collectionId: AppWriteConstant.tweetCollectionId,
    );
    return documents.documents;
  }
}
