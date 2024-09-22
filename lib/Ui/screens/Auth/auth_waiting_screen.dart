import 'package:eClassify/Ui/screens/Widgets/AnimatedRoutes/blur_page_route.dart';
import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:eClassify/app/routes.dart';
import 'package:eClassify/utils/AppIcon.dart';
import 'package:eClassify/utils/responsiveSize.dart';
import 'package:eClassify/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthWaitingScreen extends StatefulWidget {
  const AuthWaitingScreen({super.key});

  static BlurredRouter route(RouteSettings settings) {
    return BlurredRouter(
      builder: (context) {
        return const AuthWaitingScreen();
      },
    );
  }

  @override
  State<AuthWaitingScreen> createState() => _AuthWaitingScreenState();
}

class _AuthWaitingScreenState extends State<AuthWaitingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (_) => _navigateToLogin(),
      child: Scaffold(
        backgroundColor: context.color.backgroundColor,
        body: AnnotatedRegion(
          value: SystemUiOverlayStyle(
            statusBarColor: context.color.backgroundColor,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18, top: 23),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 94),
                  Align(
                    alignment: AlignmentDirectional.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10.0.rh(context)),
                      child: SizedBox(
                        width: 150.rw(context),
                        height: 150.rw(context),
                        child: UiUtils.getSvg(AppIcons.splashLogo),
                      ),
                    ),
                  ),
                  const SizedBox(height: 75),
                  Text("yourAccountWillApprovedSoon".translate(context))
                      .size(context.font.extraLarge)
                      .color(context.color.textDefaultColor)
                      .centerAlign(),
                  const SizedBox(height: 80),
                  Align(
                    alignment: AlignmentDirectional.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10.0.rh(context)),
                      child: Container(
                        width: 100.rw(context),
                        height: 100.rw(context),
                        padding: EdgeInsets.all(15.rw(context)),
                        decoration: BoxDecoration(
                          border: Border.all(width: 4),
                          shape: BoxShape.circle,
                        ),
                        child: AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) => RotationTransition(
                            turns: _controller,
                            child: child!,
                          ),
                          child: UiUtils.getSvg(AppIcons.authWaitingIcon),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text("patienceFoundationOfSuccess".translate(context))
                      .size(context.font.extraLarge)
                      .color(context.color.textDefaultColor)
                      .centerAlign(),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: _navigateToLogin,
                    child: Text("backToHome".translate(context))
                        .underline()
                        .color(context.color.territoryColor),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToLogin() {
    Future.delayed(
      Duration.zero,
      () {
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.login,
            (route) => route.isFirst,
          );
        }
      },
    );
  }
}
