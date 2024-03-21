import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tweetify/apis/user_api.dart';
import 'package:tweetify/models/user_models.dart';

final exploreControllerProvider = StateNotifierProvider((ref) {
  return ExploreController(userAPI: ref.watch(userAPIProvider));
});

// here .family will take user from ui and pass it to the controller
final searchUserProvider = FutureProvider.family((ref, String name) async {
  final exploreController = ref.watch(exploreControllerProvider.notifier);
  return exploreController.searchUser(name);
});

class ExploreController extends StateNotifier<bool> {
  final UserAPI _userAPI;
  ExploreController({required UserAPI userAPI})
      : _userAPI = userAPI,
        super(false);

  Future<List<UserModel>> searchUser(String name) async {
    final users = await _userAPI.searchUserByName(name);
    return users.map((e) => UserModel.fromMap(e.data)).toList();
  }
}
