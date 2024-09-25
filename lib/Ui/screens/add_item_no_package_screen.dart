import 'package:eClassify/Utils/AppIcon.dart';
import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:eClassify/Utils/responsiveSize.dart';
import 'package:eClassify/app/routes.dart';
import 'package:flutter/material.dart';

import '../../Utils/ui_utils.dart';

class AddItemNoPackageScreen extends StatelessWidget {
  const AddItemNoPackageScreen({super.key});

  static void open(BuildContext context) {
    Future.delayed(
      Duration.zero,
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddItemNoPackageScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const double maxWidth = 398;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: context.color.textDefaultColor),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: maxWidth),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox.square(
                dimension: 172.rh(context),
                child: UiUtils.getSvg(AppIcons.alarm),
              ),
              const SizedBox(height: 25, width: double.maxFinite),
              TextFormField(
                readOnly: true,
                enabled: false,
                initialValue: "youHaveExceededNumberOfAdsAllowedInYourPackage"
                    .translate(context),
                maxLines: 10,
                minLines: 1,
                style: const TextStyle(
                  color: Color(0xFF2F2F2F),
                  fontSize: 32,
                  fontFamily: 'Ping AR + LT',
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: " ${"sorry".translate(context)} ",
                  labelStyle: TextStyle(
                    color: context.color.territoryColor,
                    fontSize: 45,
                    fontFamily: 'Ping AR + LT',
                    fontWeight: FontWeight.w700,
                    height: 0.02,
                  ),
                  contentPadding: const EdgeInsets.all(22),
                  constraints: const BoxConstraints(maxWidth: maxWidth),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFAEAEAE)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 60),
              Row(
                children: [
                  Expanded(
                    child: _Button(
                      onTap: () {
                        Future.delayed(const Duration(seconds: 1), () {
                          Navigator.pushNamed(
                              context, Routes.subscriptionPackageListRoute);
                        });
                      },
                      backgroundColor: context.color.territoryColor,
                      textColor: Colors.white,
                      text: "renewPackage".translate(context),
                      svgPath: AppIcons.sync,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _Button(
                      onTap: () => Navigator.pop(context),
                      backgroundColor: Colors.transparent,
                      borderColor: context.color.territoryColor,
                      textColor: context.color.territoryColor,
                      text: "back".translate(context),
                      svgPath: AppIcons.rank,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.backgroundColor,
    this.borderColor,
    this.onTap,
    required this.textColor,
    required this.text,
    required this.svgPath,
  });
  final Color backgroundColor;
  final Color? borderColor;
  final Color textColor;
  final String text;
  final String svgPath;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        height: 49,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          border: borderColor == null ? null : Border.all(color: borderColor!),
          borderRadius: BorderRadius.circular(5),
          color: backgroundColor,
        ),
        child: Row(
          children: [
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 25,
                    fontFamily: 'Ping AR + LT',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox.square(
              dimension: 21,
              child: UiUtils.getSvg(
                svgPath,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
