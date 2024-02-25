import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:tweetify/core/core.dart';
// ignore: depend_on_referenced_packages
import 'package:fpdart/fpdart.dart';
import 'package:riverpod/riverpod.dart';
import 'package:tweetify/core/providers.dart';

// In AppWrite earlier version there was two Account function, one is for service like signup, login etc and another one is related to model class
// When want to get user account then use -> Account
// when want to get user realted data then use -> model.Account
// but now there user for model class and account for service

// this provider of rivrepod return read only value
final authAPIProvider = Provider((ref) {
  final account = ref.watch(appWriteAccountProvider);
  return AuthAPI(account: account);
});

abstract class IAuthAPI {
  FutureEither<User> signUp({
    required String email,
    required String password,
  });
}

class AuthAPI implements IAuthAPI {
  final Account _account;
  AuthAPI({required Account account}) : _account = account;

  @override
  FutureEither<User> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final account = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );
      return right(account);
    } on AppwriteException catch (e, stackTrace) {
      return left(
          Failure(e.message ?? 'Some unexpected error occured', stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }
// login auth
  FutureEither<Session> login({
    required String email,
    required String password,
  }) async {
    try {
      final session = await _account.createEmailSession(
        email: email,
        password: password,
      );
      return right(session);
    } on AppwriteException catch (e, stackTrace) {
      return left(
          Failure(e.message ?? 'Some unexpected error occured', stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }
}
