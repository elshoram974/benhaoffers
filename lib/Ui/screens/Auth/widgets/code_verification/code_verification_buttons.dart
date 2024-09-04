import 'package:flutter/material.dart';

import 'resend_code_button/resend_code_button.dart';

class CodeVerificationButtons extends StatelessWidget {
  const CodeVerificationButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 53),
        // AuthFilledButton(
        //   text: S.of(context).verify,
        //   onPressed: ProviderDependency.verificationCode.verifyCode,
        // ),
        const SizedBox(height: 8),
        const ResendCodeButton(),
      ],
    );
  }
}
