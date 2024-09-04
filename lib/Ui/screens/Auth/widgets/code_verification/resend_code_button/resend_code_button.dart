import 'package:flutter/material.dart';

import 'resend_widget.dart';
import 'waiting_timer_widget.dart';

class ResendCodeButton extends StatelessWidget {
  const ResendCodeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ResendWidget(),
        WaitingTimerWidget(),
      ],
    );
  }
}
