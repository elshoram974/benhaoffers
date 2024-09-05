import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:eClassify/Utils/helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/cubits/auth/new_password_cubit/new_password_cubit.dart';
import '../Widgets/AnimatedRoutes/blur_page_route.dart';
import 'widgets/new_password/new_password_body.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key, required this.email});
  final String email;

  static BlurredRouter route(RouteSettings routeSettings) {
    final String email = routeSettings.arguments as String;
    return BlurredRouter(
      builder: (_) => BlocProvider(
        create: (context) => CreateNewPasswordCubit(email),
        child: NewPasswordScreen(email: email),
      ),
    );
  }

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  bool canPop = false;

  DateTime? currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvoked: (didPop) {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime!).inSeconds > 2) {
          currentBackPressTime = now;

          HelperUtils.showSnackBarMessage(
            context,
            messageDuration: 2,
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
      child: const Scaffold(body: NewPasswordBody()),
    );
  }
}
