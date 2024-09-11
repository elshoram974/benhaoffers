import 'package:eClassify/Ui/screens/Home/home_screen.dart';
import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:eClassify/Utils/ui_utils.dart';
import 'package:flutter/material.dart';

import '../../../../../data/cubits/auth/new_password_cubit/new_password_cubit.dart';
import '../../../../../exports/main_export.dart';
import '../../../Widgets/custom_text_form_field.dart';

class NewPasswordBody extends StatelessWidget {
  const NewPasswordBody({super.key});

  @override
  Widget build(BuildContext context) {
    final CreateNewPasswordCubit cubit =
        BlocProvider.of<CreateNewPasswordCubit>(context);
    bool isObscure = true;

    return SafeArea(
      child: Scaffold(
        backgroundColor: context.color.backgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: sidePadding),
          child: Form(
            key: cubit.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                Text("createNewPassword".translate(context))
                    .size(context.font.extraLarge),
                const SizedBox(height: 20),
                Text("yourNewPasswordMustBeDifferentFromPreviously"
                        .translate(context))
                    .size(context.font.large),
                const SizedBox(height: 8),
                Text(cubit.email)
                    .size(context.font.small)
                    .color(context.color.textLightColor),
                const SizedBox(height: 24),
                StatefulBuilder(
                  builder: (context, setState) {
                    return CustomTextFormField(
                      hintText: "${"createNewPassword".translate(context)}*",
                      validator: CustomTextFieldValidator.password,
                      obscureText: isObscure,
                      onChange: cubit.onChangePassword,
                      onEditingComplete: () => cubit.saveNewPassword(context),
                      suffix: IconButton(
                        onPressed: () {
                          isObscure = !isObscure;
                          setState(() {});
                        },
                        icon: Icon(
                          isObscure ? Icons.visibility_off : Icons.visibility,
                          color: context.color.textColorDark.withOpacity(0.3),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 25),
                BlocBuilder<CreateNewPasswordCubit, CreateNewPasswordState>(
                  buildWhen: (p, c) => c is CreateNewPasswordChangeTextState,
                  builder: (context, state) {
                    return UiUtils.buildButton(
                      context,
                      disabled: !cubit.isValidPass,
                      disabledColor: context.color.deactivateColor,
                      onPressed: () => cubit.saveNewPassword(context),
                      buttonTitle: "submitBtnLbl".translate(context),
                      radius: 8,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
