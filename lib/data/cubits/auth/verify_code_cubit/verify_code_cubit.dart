import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Utils/helper_utils.dart';
import '../../../Repositories/auth_repository.dart';
import '../../../helper/widgets.dart';

part 'verify_code_state.dart';

class VerifyCodeCubit extends Cubit<VerifyCodeState> {
  VerifyCodeCubit() : super(const VerifyCodeInitial());

  final AuthRepository repo = AuthRepository();
  bool submitIsEnabled = false;
  String email = '';

  // * verify Code----------------------------
  String code = '';
  void onChangeCode(String val) {
    code = val;
    submitIsEnabled = code.length == 6;
    emit(VerifyCodeSubmitState(submitIsEnabled));
  }

  void verifyCode(BuildContext context) async {
    if (code.length < 6 || state is VerifyCodeLoadingState) return;
    Widgets.showLoader(context);

    emit(const VerifyCodeLoadingState());
    // final Status<User> verifyStatus = await verifyCodeUseCase((
    //   id: user.userId,
    //   code: code,
    //   verification: verificationFromNextRoute(),
    // ));
    if (context.mounted) Widgets.hideLoder(context);

    // if (verifyStatus is Success<User>) {
    //   _verifySuccess(verifyStatus.data, nextRoute);
    // } else if (verifyStatus is Failure<User>) {
    //   if (context.mounted) _failureState(verifyStatus.failure.message, context);
    // }
  }

  // end verify Code----------------------------

  void _verifySuccess() {
    _timer.cancel();
    emit(VerifyCodeSuccessState());
    // if (nextRoute == AppRoute.userHome) {
    //   if (user.userType == UserType.business) {
    //     // TODO: to admin home
    //   } else {
    //     AppRoute.key.currentContext!.go(AppRoute.userHome, extra: user);
    //   }
    // } else {
    //   AppRoute.key.currentContext!.pushReplacement(nextRoute, extra: user.id);
    // }
  }

  void _failureState(String error, BuildContext context) {
    emit(VerifyCodeFailureState(error));
    HelperUtils.showSnackBarMessage(context, error);
  }

  // * resend Code----------------------------
  late Timer _timer;
  int waitingTime = 0;
  void sendCode(BuildContext context) async {
    emit(const VerifyCodeLoadingState());
    Widgets.showLoader(context);

    try {
      await repo.requestToSendCode(email);
      if (context.mounted) Widgets.hideLoder(context);
      _start();
    } catch (e) {
      if (context.mounted) {
        Widgets.hideLoder(context);
        _failureState("Failed to send code $e", context);
      }
    }
  }

  void _start() {
    // if (_timer.isActive) _timer.cancel();
    waitingTime = 90;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        waitingTime--;
        emit(VerifyCodeLoadingResendCodeState(waitingTime));
        if (waitingTime <= 0) timer.cancel();
      },
    );
  }

  // end resend Code----------------------------
  void onWillPop() => _timer.cancel();
}
