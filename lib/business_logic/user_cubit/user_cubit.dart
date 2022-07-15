import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../data/dio_helper.dart';
import '../../data/models/identity/user_model.dart';
import '../../shared/constants.dart';
import '../../shared/resources/constants_manager.dart';
import 'user_states.dart';

class UserCubit extends Cubit<UserStates> {
  UserCubit() : super(UserInitialState());
  static UserCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;
  String errorMessage = "Error";
  String successMessage = "Success";

  void userLogin({
    required String email,
    required String password,
  }) async {
    emit(LoginLoadingState());
    await DioHelper.postData(url: ConstantsManager.Login, data: {
      "email": email,
      "password": password,
    }).then((value) {
      print(value);
      userModel = UserModel.fromJson(value);
      successMessage = "Login done successfully";
      emit(LoginSuccessState(userModel!));
    }).catchError((error) {
      errorMessage = error;
      print(error.toString());
      emit(LoginErrorState(error.toString()));
    });
  }

  void userRegister({
    required String email,
    required String name,
    required String phone,
    required String password,
  }) async {
    emit(EmailExistLoadingState());
    String basketId = Uuid().v4();
    print(basketId);
    await DioHelper.getData(
        url: ConstantsManager.IsEmailExist,
        query: {"email": email}).then((value) {
      if (!value) {
        emit(RegisterLoadingState());
        DioHelper.postData(url: ConstantsManager.Register, data: {
          "displayName": name,
          "email": email,
          "password": password,
          "phoneNumber": phone,
          "userBasketId": basketId,
        }).then((value) {
          userModel = UserModel.fromJson(value);
          successMessage = "Register done successfully";
          emit(RegisterSuccessState(userModel!));
        }).catchError((error) {
          errorMessage = error;
          emit(RegisterErrorState(error.toString()));
        });
      } else {
        errorMessage =
            "The Email you entered has already been exist. try another email";
        emit(EmailExistSuccessState());
      }
    }).catchError((error) {
      errorMessage = error;
      emit(EmailExistErrorState());
    });
  }

  void changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    emit(ChangePasswordLoadingState());
    DioHelper.putData(
        url: ConstantsManager.ChangePassword,
        token: token,
        data: {
          "password": oldPassword,
          "newPassword": newPassword,
        }).then((value) {
      successMessage = "Password Changed successfully";
      emit(ChangePasswordSuccessState());
    }).catchError((error) {
      errorMessage = error;
      emit(ChangePasswordErrorState(error.toString()));
    });
  }

  void getUserData() async {
    print(token);
    emit(GetUserDataLoadingState());
    await DioHelper.getData(url: ConstantsManager.Account, token: token)
        .then((data) {
      print("USER DATA $data");
      userModel = UserModel.fromJson(data);
      basketId = userModel!.basketId!;
      emit(GetUserDataSuccessState(userModel!));
    }).catchError((error) {
      emit(GetUserDataErrorState());
      print('Get User Model Error ${error.toString()}');
    });
  }

  void changeUserData({
    String name = "",
    String? email = "",
    String? phone = "",
  }) {
    emit(UpdateUserDataLoadingState());
    DioHelper.putData(
      url: ConstantsManager.Edit,
      token: token,
      data: {
        "newDisplayName": name,
        "newEmail": email,
        "newPhoneNumber": phone,
      },
    ).then((data) {
      successMessage = "Data Updated Successfully";
      userModel = UserModel.fromJson(data);
      emit(UpdateUserDataSuccessState(userModel!));
    }).catchError((error) {
      errorMessage = "Error while updating info.";
      print('Update User Model Error ${error.toString()}');
      emit(UpdateUserDataErrorState());
    });
  }
}
