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
  // provider to get the instance of the database and realtime
  return TweetAPI(
    db: ref.watch(appWriteDatabaseProvider),
    realtime: ref.watch(appWriteRealtimeProvider),
  );
});

abstract class ITweetAPI {
  FutureEither<Document> shareTweet(Tweet tweet);
  Future<List<Document>> getTweets();
  Stream<RealtimeMessage> getLatestTweets();
  FutureEither<Document> likeTweet(Tweet tweet);
  FutureEither<Document> updateReshareCount(Tweet tweet);
}

class TweetAPI implements ITweetAPI {
  final Databases _db;
  final Realtime _realtime;
  TweetAPI({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;
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
      queries: [
        Query.orderDesc('tweetedAt'),
      ],
    );
    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestTweets() {
    return _realtime.subscribe([
      // this will go to the collection and listen for the changes
      'databases.${AppWriteConstant.databaseId}.collections.${AppWriteConstant.tweetCollectionId}.documents',
    ]).stream;
  }

  @override
  FutureEither<Document> likeTweet(Tweet tweet) async {
    try {
      final document = await _db.updateDocument(
          databaseId: AppWriteConstant.databaseId,
          collectionId: AppWriteConstant.tweetCollectionId,
          documentId: tweet.id,
          data: {'likes': tweet.likes});
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(Failure(e.message ?? 'Something went wrong', st));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }
  
  @override
  FutureEither<Document> updateReshareCount(Tweet tweet) async{
    try {
      final document = await _db.updateDocument(
          databaseId: AppWriteConstant.databaseId,
          collectionId: AppWriteConstant.tweetCollectionId,
          documentId: tweet.id,
          data: {'reshareCount': tweet.reshareCount});
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(Failure(e.message ?? 'Something went wrong', st));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
    }
}
