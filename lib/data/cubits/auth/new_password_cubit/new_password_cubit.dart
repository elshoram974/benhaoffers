import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:eClassify/Utils/helper_utils.dart';
import 'package:eClassify/app/routes.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Repositories/auth_repository.dart';
import '../../../helper/widgets.dart';

part 'new_password_state.dart';

class CreateNewPasswordCubit extends Cubit<CreateNewPasswordState> {
  final String email;
  CreateNewPasswordCubit(this.email) : super(const CreateNewPasswordInitial());

  final AuthRepository repo = AuthRepository();
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
    Widgets.showLoader(context);

    try {
      await repo.createNewPassword(email, newPassword);
      if (context.mounted) {
        Widgets.hideLoder(context);
        _savedSuccess(context);
      }
    } catch (e) {
      if (context.mounted) {
        Widgets.hideLoder(context);
        _failureState(e.toString(), context);
      }
    }
  }

  // end saved new password Code----------------------------

  void _savedSuccess(BuildContext context) {
    emit(const CreateNewPasswordSuccessState());
    HelperUtils.showSnackBarMessage(
      context,
      "passwordChangeSuccess".translate(context),
    );

    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.login,
      (route) => route.isFirst,
    );
  }

  void _failureState(String error, BuildContext context) {
    emit(CreateNewPasswordFailureState(error));
    HelperUtils.showSnackBarMessage(context, error);
  }
}
