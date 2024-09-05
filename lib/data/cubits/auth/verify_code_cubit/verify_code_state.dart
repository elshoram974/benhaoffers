part of 'verify_code_cubit.dart';

sealed class VerifyCodeState extends Equatable {
  const VerifyCodeState();

  @override
  List<Object> get props => [];
}

final class VerifyCodeInitial extends VerifyCodeState {
  const VerifyCodeInitial();
}

final class VerifyCodeLoadingState extends VerifyCodeState {
  const VerifyCodeLoadingState();
}

final class VerifyCodeSubmitState extends VerifyCodeState {
  final bool isEnabled;
  const VerifyCodeSubmitState(this.isEnabled);

  @override
  List<bool> get props => [isEnabled];
}

final class VerifyCodeLoadingResendCodeState extends VerifyCodeState {
  final int duration;
  const VerifyCodeLoadingResendCodeState(this.duration);

  @override
  List<int> get props => [duration];
}

final class VerifyCodeSuccessState extends VerifyCodeState {
  const VerifyCodeSuccessState();
}

final class VerifyCodeFailureState extends VerifyCodeState {
  final String error;
  const VerifyCodeFailureState(this.error);
  @override
  List<String> get props => [error];
}
