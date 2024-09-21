import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:eClassify/Utils/api.dart';
import 'package:eClassify/app/routes.dart';
import 'package:flutter/material.dart';

class TermAndPolicyTxt extends StatelessWidget {
  const TermAndPolicyTxt({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
          bottom: 15.0, start: 25.0, end: 25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("bySigningUpLoggingIn".translate(context))
              .centerAlign()
              .size(context.font.small)
              .color(context.color.textLightColor.withOpacity(0.8)),
          const SizedBox(
            height: 3,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                child: Text("termsOfService".translate(context))
                    .underline()
                    .color(context.color.territoryColor)
                    .size(context.font.small),
                onTap: () => Navigator.pushNamed(
                  context,
                  Routes.profileSettings,
                  arguments: {
                    'title': "termsConditions".translate(context),
                    'param': Api.termsAndConditions
                  },
                ),
              ),
              /*CustomTextButton(
                text:Text("termsOfService".translate(context)).underline().color(context.color.teritoryColor).size(context.font.small),
                onPressed: () => Navigator.pushNamed(
                        context, Routes.profileSettings,
                        arguments: {
                          'title': UiUtils.getTranslatedLabel(
                              context, "termsConditions"),
                          'param': Api.termsAndConditions
                        })),*/
              const SizedBox(width: 5.0),
              Text("andTxt".translate(context))
                  .size(context.font.small)
                  .color(context.color.textLightColor.withOpacity(0.8)),
              const SizedBox(width: 5.0),
              InkWell(
                child: Text("privacyPolicy".translate(context))
                    .underline()
                    .color(context.color.territoryColor)
                    .size(context.font.small),
                onTap: () => Navigator.pushNamed(
                  context,
                  Routes.profileSettings,
                  arguments: {
                    'title': "privacyPolicy".translate(context),
                    'param': Api.privacyPolicy
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
