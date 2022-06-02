import 'package:graduation_project/data/models/identity/user_model.dart';

abstract class UserStates {}

class UserInitialState extends UserStates {}

class LoginSuccessState extends UserStates {
  final UserModel loginModel;

  LoginSuccessState(this.loginModel);
}

class LoginLoadingState extends UserStates {}

class LoginErrorState extends UserStates {
  final String error;

  LoginErrorState(this.error);
}

class RegisterSuccessState extends UserStates {
  final UserModel loginModel;

  RegisterSuccessState(this.loginModel);
}

class RegisterLoadingState extends UserStates {}

class RegisterErrorState extends UserStates {
  final String error;

  RegisterErrorState(this.error);
}

class EmailExistSuccessState extends UserStates {}

class EmailExistLoadingState extends UserStates {}

class EmailExistErrorState extends UserStates {}

class LogoutSuccessState extends UserStates {}

class LogoutLoadingState extends UserStates {}

class LogoutErrorState extends UserStates {
  final String error;

  LogoutErrorState(this.error);
}

class ChangePasswordSuccessState extends UserStates {}

class ChangePasswordLoadingState extends UserStates {}

class ChangePasswordErrorState extends UserStates {
  final String error;

  ChangePasswordErrorState(this.error);
}

class GetUserDataLoadingState extends UserStates {}

class GetUserDataSuccessState extends UserStates {
  final UserModel userModel;
  GetUserDataSuccessState(this.userModel);
}

class GetUserDataErrorState extends UserStates {}

class UpdateUserDataLoadingState extends UserStates {}

class UpdateUserDataSuccessState extends UserStates {
  final UserModel userModel;
  UpdateUserDataSuccessState(this.userModel);
}

class UpdateUserDataErrorState extends UserStates {}
