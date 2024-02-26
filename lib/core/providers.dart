import 'package:appwrite/appwrite.dart';
import 'package:riverpod/riverpod.dart';
import 'package:tweetify/constants/appwrite_constant.dart';

final appWriteClientProvider = Provider((ref) {
  Client client = Client();
  return client
      // these will connect to appwrite dashboard
      .setEndpoint(AppWriteConstant.endPoint)
      .setProject(AppWriteConstant.projectId)
      .setSelfSigned(status: true);
});

final appWriteAccountProvider = Provider((ref) {
  // we can use ref.read also but that will look into the above only once and execute
  // in ref.write it will look for every changes and then execute
  final client = ref.watch(appWriteClientProvider);
  return Account(client);
});

final appWriteDatabaseProvider = Provider((ref) {
  final client = ref.watch(appWriteClientProvider);
  return Databases(client);
});