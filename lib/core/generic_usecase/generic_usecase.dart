
import 'package:dartz/dartz.dart';

import '../errors/failure.dart';

abstract class GenericUseCase<Type,Params>{
  Future<Either<Failure,Type>> call(Params params);
}
class NoParams {}