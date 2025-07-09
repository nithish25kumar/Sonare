import 'package:dartz/dartz.dart';
import 'package:spotify2/domain/repository/auth/auth.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';

class GetUserUseCase implements UseCase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return await sl<AuthRepository>().getUser();
  }
}
