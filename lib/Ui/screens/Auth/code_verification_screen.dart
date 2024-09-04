import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:eClassify/Utils/helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/cubits/auth/verify_code_cubit/verify_code_cubit.dart';
import '../Widgets/AnimatedRoutes/blur_page_route.dart';
import 'widgets/code_verification/code_verification_body.dart';

class CodeVerificationScreen extends StatefulWidget {
  const CodeVerificationScreen({super.key, required this.email});

  final String email;

  static BlurredRouter route(RouteSettings routeSettings) {
    return BlurredRouter(
      builder: (_) => BlocProvider(
        create: (context) => VerifyCodeCubit(),
        child: CodeVerificationScreen(email: routeSettings.arguments as String),
      ),
    );
  }

  @override
  State<CodeVerificationScreen> createState() => _CodeVerificationScreenState();
}

class _CodeVerificationScreenState extends State<CodeVerificationScreen> {
  late final VerifyCodeCubit cubit = BlocProvider.of<VerifyCodeCubit>(context);
  bool canPop = false;

  DateTime? currentBackPressTime;

  @override
  void initState() {
    cubit.email = widget.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvoked: (didPop) {
        if (canPop) cubit.onWillPop();
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime!).inSeconds > 2) {
          currentBackPressTime = now;

          HelperUtils.showSnackBarMessage(
            context,
            "pressAgainToExit".translate(context),
          );
          canPop = true;
          setState(() {});
        }
        Future.delayed(
          const Duration(seconds: 2),
          () {
            if (!context.mounted) return;
            canPop = false;
            setState(() {});
          },
        );
      },
      child: const Scaffold(body: CodeVerificationBody()),
    );
  }
}
