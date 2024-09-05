part of 'new_password_cubit.dart';

sealed class CreateNewPasswordState extends Equatable {
  const CreateNewPasswordState();

  @override
  List<Object> get props => [];
}

final class CreateNewPasswordInitial extends CreateNewPasswordState {
  const CreateNewPasswordInitial();
}

final class CreateNewPasswordLoadingState extends CreateNewPasswordState {
  const CreateNewPasswordLoadingState();
}

final class CreateNewPasswordChangeTextState extends CreateNewPasswordState {
  final String val;
  const CreateNewPasswordChangeTextState(this.val);
  @override
  List<String> get props => [val];
}
final class CreateNewPasswordSuccessState extends CreateNewPasswordState {
  final Map<String,dynamic> data;
  const CreateNewPasswordSuccessState(this.data);
  @override
  List<Map<String,dynamic>> get props => [data];
}

final class CreateNewPasswordFailureState extends CreateNewPasswordState {
  final String error;
  const CreateNewPasswordFailureState(this.error);
  @override
  List<String> get props => [error];
}
