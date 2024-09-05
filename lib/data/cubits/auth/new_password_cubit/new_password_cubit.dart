import 'package:eClassify/Utils/helper_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'new_password_state.dart';

class CreateNewPasswordCubit extends Cubit<CreateNewPasswordState> {
  final String email;

  CreateNewPasswordCubit(this.email) : super(const CreateNewPasswordInitial());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String newPassword = '';
  bool isValidPass = false;

  void onChangePassword(String val) {
    newPassword = val;
    isValidPass = formKey.currentState?.validate() ?? false;
    emit(CreateNewPasswordChangeTextState(val));
  }

  // * save new password----------------------------
  void saveNewPassword(BuildContext context) async {
    if (!isValidPass) return;

    emit(const CreateNewPasswordLoadingState());

    // EasyLoading.show(dismissOnTap: false);

    // final Status<User> savedStatus = await createNewPasswordUseCase((
    //   id: userId,
    //   newPass: newPassword,
    // ));
    // await EasyLoading.dismiss();
    // if (savedStatus is Success<User>) {
    //   _savedSuccess(savedStatus.data.copyWith(password: newPassword));
    // } else if (savedStatus is Failure<User>) {
    //   _failureState(savedStatus.failure.message);
    // }
  }

  // end saved new password Code----------------------------

  void _savedSuccess(Map<String, dynamic> data) {
    emit(CreateNewPasswordSuccessState(data));
    // TextInput.finishAutofillContext();
    // if (user.userType == UserType.business) {
    //   // TODO: to admin home
    // } else {
    //   AppRoute.key.currentContext!.go(AppRoute.userHome, extra: user);
    // }
  }

  void _failureState(String error, BuildContext context) {
    emit(CreateNewPasswordFailureState(error));
    HelperUtils.showSnackBarMessage(context, error);
  }
}
