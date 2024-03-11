import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:riverpod/riverpod.dart';
import 'package:tweetify/constants/appwrite_constant.dart';
import 'package:tweetify/core/providers.dart';

final storageAPIProvider = Provider((ref) {
  return StorageAPI(
    storage: ref.watch(
      appWriteStorageProvider,
    ),
  );
});

class StorageAPI {
  final Storage _storage;
  StorageAPI({required Storage storage}) : _storage = storage;

  Future<List<String>> uploadImage(List<File> files) async {
    final List<String> imageLinks = [];
    for (final file in files) {
      final uploadedImage = await _storage.createFile(
        bucketId: AppWriteConstant.imagesBucket,
        fileId: ID.unique(),
        file: InputFile.fromPath(
          path: file.path,
        ),
      );
      imageLinks.add(AppWriteConstant.imageUrl(uploadedImage.$id));
    }
    return imageLinks;
  }
}
