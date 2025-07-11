import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify2/presentation/profile/bloc/profile_info_state.dart';

class ProfileInfoCubit extends Cubit<ProfileInfoState> {
  ProfileInfoCubit() : super(ProfileInfoLoading());
}
