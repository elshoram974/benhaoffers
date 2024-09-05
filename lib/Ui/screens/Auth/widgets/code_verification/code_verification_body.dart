import 'package:eClassify/Ui/screens/Home/home_screen.dart';
import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:eClassify/Utils/ui_utils.dart';
import 'package:flutter/material.dart';

import '../../../../../data/cubits/auth/verify_code_cubit/verify_code_cubit.dart';
import '../../../../../exports/main_export.dart';
import 'code_fields.dart';
import 'code_verification_buttons.dart';

class CodeVerificationBody extends StatelessWidget {
  const CodeVerificationBody({super.key});

  @override
  Widget build(BuildContext context) {
  final VerifyCodeCubit cubit = BlocProvider.of<VerifyCodeCubit>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: context.color.backgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: sidePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: FittedBox(
                  fit: BoxFit.none,
                  child: MaterialButton(
                    onPressed: () {
                      cubit.onWillPop();
                      Navigator.pushNamed(
                        context,
                        Routes.main,
                        arguments: {
                          "from": "login",
                          "isSkipped": true,
                        },
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    color: context.color.forthColor.withOpacity(0.102),
                    elevation: 0,
                    height: 28,
                    minWidth: 64,
                    child: Text("skip".translate(context))
                        .color(context.color.forthColor),
                  ),
                ),
              ),
              const SizedBox(height: 66),
              Text("codeVerification".translate(context))
                  .size(context.font.extraLarge),
              const SizedBox(height: 20),
              Text("enterDigitCodeThatHasBeenSentToYourEmail"
                      .translate(context))
                  .size(context.font.large),
              const SizedBox(height: 8),
              Text(cubit.email)
                  .size(context.font.small)
                  .color(context.color.textLightColor),
              const SizedBox(height: 24),
              const CodeFields(),
              const CodeVerificationButtons(),
              const SizedBox(height: 25),
              BlocBuilder<VerifyCodeCubit, VerifyCodeState>(
                buildWhen: (p, c) => c is VerifyCodeSubmitState,
                builder: (context, state) {
                  return UiUtils.buildButton(
                    context,
                    disabled: !cubit.submitIsEnabled,
                    disabledColor: context.color.deactivateColor,
                    onPressed: () => cubit.verifyCode(context),
                    buttonTitle: "submitBtnLbl".translate(context),
                    radius: 8,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
    // AuthBody(
    //   previousRouteNameFunction: (_) => S.of(_).codeVerification,
    //   introHeader: "S.of(context).codeVerification",
    //   introBody: "S.of(context).enterDigitCodeThatHasBeenSentToYourEmail",
    //   onWillPop: cubit,
    //   children: const [
    //     CodeFields(),
    //     CodeVerificationButtons(),
    //   ],
    // );
  }
}
