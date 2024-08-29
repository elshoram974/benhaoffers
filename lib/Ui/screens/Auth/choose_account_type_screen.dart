import 'package:eClassify/Ui/screens/Widgets/AnimatedRoutes/blur_page_route.dart';
import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:eClassify/Utils/helper_utils.dart';
import 'package:eClassify/exports/main_export.dart';
import 'package:eClassify/utils/AppIcon.dart';
import 'package:eClassify/utils/responsiveSize.dart';
import 'package:eClassify/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'signup_screen.dart';

class ChooseAccountTypeScreen extends StatelessWidget {
  const ChooseAccountTypeScreen({super.key});

  static BlurredRouter route(RouteSettings settings) {
    return BlurredRouter(
      builder: (context) {
        return const ChooseAccountTypeScreen();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Align(
                  alignment: AlignmentDirectional.bottomEnd,
                  child: FittedBox(
                    fit: BoxFit.none,
                    child: MaterialButton(
                      onPressed: () {
                        HelperUtils.killPreviousPages(context, Routes.main, {
                          "from": "login",
                          "isSkipped": true,
                        });
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
                Text("signUpToeClassify".translate(context))
                    .size(context.font.extraLarge)
                    .color(context.color.textDefaultColor),
                const SizedBox(height: 42),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: _TypeButton(
                        text: "user".translate(context),
                        iconPath: AppIcons.userIcon,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.signup,
                            arguments: {'user_type': UserType.user.typeString},
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 30),
                    Flexible(
                      child: _TypeButton(
                        text: "vendor_businessOwner".translate(context),
                        iconPath: AppIcons.vendorIcon,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.signup,
                            arguments: {'user_type': UserType.vendor.typeString},
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("alreadyHaveAcc".translate(context))
                        .color(context.color.textColorDark.brighten(50)),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text("login".translate(context))
                          .underline()
                          .color(context.color.territoryColor),
                    )
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  const _TypeButton({
    required this.text,
    required this.iconPath,
    required this.onTap,
  });

  final String text;
  final String iconPath;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(21),
      child: Container(
        height: 162.rh(context),
        width: 162.rh(context),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffCAC8C8)),
          borderRadius: BorderRadius.circular(21),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UiUtils.getSvg(
              iconPath,
              color: context.color.territoryColor,
              height: 77.rh(context),
              width: 77.rh(context),
            ),
            Flexible(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.rf(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
