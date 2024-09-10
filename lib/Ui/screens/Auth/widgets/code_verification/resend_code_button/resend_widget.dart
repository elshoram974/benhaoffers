import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../data/cubits/auth/verify_code_cubit/verify_code_cubit.dart';

class ResendWidget extends StatelessWidget {
  const ResendWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final VerifyCodeCubit cubit = BlocProvider.of<VerifyCodeCubit>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("noCodeReceived".translate(context))
            .color(context.color.textColorDark.brighten(50)),
        const SizedBox(width: 12),
        BlocBuilder<VerifyCodeCubit, VerifyCodeState>(
          buildWhen: (p, c) => c is VerifyCodeLoadingResendCodeState,
          builder: (context, state) {
            return TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed:
                  cubit.waitingTime == 0 ? () => cubit.sendCode(context) : null,
              child: Text("resend".translate(context)),
            );
          },
        ),
      ],
    );
  }
}
