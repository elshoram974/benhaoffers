import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../../../../../../data/cubits/auth/verify_code_cubit/verify_code_cubit.dart';

class WaitingTimerWidget extends StatelessWidget {
  const WaitingTimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final VerifyCodeCubit cubit = BlocProvider.of<VerifyCodeCubit>(context);

    return BlocBuilder<VerifyCodeCubit, VerifyCodeState>(
      buildWhen: (p, c) => c is VerifyCodeLoadingResendCodeState,
      builder: (context, state) {
        return Visibility(
          visible: cubit.waitingTime != 0,
          child: SlideCountdown(
            duration: const Duration(seconds: 90),
            decoration: const BoxDecoration(color: Colors.transparent),
            separator: ":",
            shouldShowMinutes: (_) => true,
            shouldShowSeconds: (_) => true,
            style: Theme.of(context).textTheme.bodySmall!,
            separatorStyle: Theme.of(context).textTheme.bodySmall!,
          ),
        );
      },
    );
  }
}
