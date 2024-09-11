import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

import '../../../../../data/cubits/auth/verify_code_cubit/verify_code_cubit.dart';

class CodeFields extends StatelessWidget {
  const CodeFields({super.key});

  @override
  Widget build(BuildContext context) {
    final VerifyCodeCubit cubit = BlocProvider.of<VerifyCodeCubit>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 57),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Pinput(
          onChanged: cubit.onChangeCode,
          onSubmitted: (val) => cubit.verifyCode(context),
          onCompleted: (val) => cubit.verifyCode(context),
          length: 6,
          autofocus: true,
          keyboardType: TextInputType.visiblePassword,
          // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          defaultPinTheme: PinTheme(
            height: 48,
            width: 54,
            textStyle: const TextStyle(color: Colors.black),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: context.color.inversePrimary),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
