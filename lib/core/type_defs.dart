import 'package:fpdart/fpdart.dart';
import 'package:tweetify/core/failure.dart';
// here T is generic type which will allow us to define datatype dynamically
typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherVoid = FutureEither<void>;
