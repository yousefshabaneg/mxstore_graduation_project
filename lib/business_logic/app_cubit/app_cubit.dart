import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'app_states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  bool appBarShow = true;

  bool isPassword = true;
  bool isConfirmNewPassword = true;
  bool isNewPassword = true;
  IconData suffix = FontAwesomeIcons.eye;
  IconData newPasswordSuffix = FontAwesomeIcons.eye;
  IconData confirmNewPasswordSuffix = FontAwesomeIcons.eye;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix = isPassword ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash;
    emit(ChangePasswordVisibility());
  }

  void changeNewPasswordVisibility() {
    isNewPassword = !isNewPassword;
    newPasswordSuffix =
        isNewPassword ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash;
    emit(ChangePasswordVisibility());
  }

  void changeConfirmNewPasswordVisibility() {
    isConfirmNewPassword = !isConfirmNewPassword;
    confirmNewPasswordSuffix =
        isConfirmNewPassword ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash;
    emit(ChangePasswordVisibility());
  }

  void resetVisibilityPassword() {
    isPassword = true;
    isConfirmNewPassword = true;
    isNewPassword = true;
    suffix = FontAwesomeIcons.eye;
    newPasswordSuffix = FontAwesomeIcons.eye;
    confirmNewPasswordSuffix = FontAwesomeIcons.eye;
  }

  void changeBottomNav(int index) {
    appBarShow = index == 0 || index == 1;
    currentIndex = index;
    emit(AppChangeBottomNavState());
  }
}
