import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eClassify/Ui/screens/Widgets/AnimatedRoutes/blur_page_route.dart';
import 'package:eClassify/Ui/screens/Widgets/custom_text_form_field.dart';
import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:eClassify/Utils/Login/lib/payloads.dart';
import 'package:eClassify/Utils/cloudState/cloud_state.dart';
import 'package:eClassify/Utils/helper_utils.dart';
import 'package:eClassify/Utils/responsiveSize.dart';
import 'package:eClassify/Utils/validator.dart';
import 'package:eClassify/data/Repositories/category_repository.dart';
import 'package:eClassify/exports/main_export.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../Utils/AppIcon.dart';
import '../../../Utils/api.dart';
import '../../../Utils/ui_utils.dart';
import '../../../data/cubits/auth/authentication_cubit.dart';
import '../../../data/model/category_model.dart';
import '../../../data/model/user_model.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key, required this.userType});

  final UserType userType;

  static BlurredRouter route(RouteSettings settings) {
    final Map arguments = settings.arguments as Map;
    return BlurredRouter(
      builder: (context) {
        return SignupScreen(
          userType: UserType.fromString(arguments['user_type'] as String),
        );
      },
    );
  }

  @override
  CloudState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends CloudState<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isObscure = true;

  CategoryModel? _tempSelectedCat;

  List<CategoryModel> categories = [];

  @override
  void initState() {
    if (UserType.provider == widget.userType) getAllCategories();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _projectNameController.dispose();
    _categoryController.dispose();
    _passwordController.dispose();
  }

  void getAllCategories() async {
    await CategoryRepository()
        .fetchCategories(page: 1, limit: 1000)
        .then((value) {
      setState(() {
        categories = value.modelList;
      });
    });
  }

  void onTapSignup() async {
    if (_formKey.currentState?.validate() ?? false) {
      final Map<String, String> map = {};
      map[Api.type] = AuthenticationType.email.name;
      map[Api.email] = _emailController.text.trim();
      map[Api.password] = _passwordController.text;
      map[Api.name] = _usernameController.text.trim();
      map[Api.userType] = widget.userType.name;

      if (UserType.provider == widget.userType) {
        map[Api.projectName] = _projectNameController.text.trim();
        map[Api.categoryId] = _categoryController.text;
      }

      addCloudData("signup_details", map);
      context.read<AuthenticationCubit>().setData(
            payload: EmailLoginPayload(
              email: _emailController.text,
              password: _passwordController.text,
              type: EmailLoginType.signup,
            ),
            type: AuthenticationType.email,
          );
      context.read<AuthenticationCubit>().authenticate();
    }
  }

  void _navigateTo() {
    HelperUtils.showSnackBarMessage(
      context,
      "accountCreatedSuccessfully".translate(context),
    );
    if (UserType.provider == widget.userType) {
      Navigator.pushReplacementNamed(context, Routes.authWaiting);
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.login,
        (route) => route.isFirst,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.backgroundColor,
      bottomNavigationBar: termAndPolicyTxt(),
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle(
          statusBarColor: context.color.backgroundColor,
        ),
        child: BlocConsumer<AuthenticationCubit, AuthenticationState>(
          listener: (context, state) {
            if (state is AuthenticationSuccess) {
              if (state.type == AuthenticationType.email) _navigateTo();
            }

            if (state is AuthenticationFail) {
              if (state.error is FirebaseAuthException) {
                HelperUtils.showSnackBarMessage(
                  context,
                  (state.error as FirebaseAuthException).message!,
                );
              } else if (state.error is DioException) {
                HelperUtils.showSnackBarMessage(
                  context,
                  (state.error as DioException).message!,
                );
              }
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 18.0, right: 18, top: 23),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.bottomEnd,
                        child: FittedBox(
                          fit: BoxFit.none,
                          child: MaterialButton(
                            onPressed: () {
                              HelperUtils.killPreviousPages(
                                  context, Routes.main, {
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
                      Text("welcome".translate(context))
                          .size(context.font.extraLarge),
                      const SizedBox(
                        height: 8,
                      ),
                      Text("signUpToeClassify".translate(context))
                          .size(context.font.large)
                          .color(context.color.textColorDark.brighten(50)),
                      const SizedBox(height: 24),
                      CustomTextFormField(
                        controller: _usernameController,
                        fillColor: context.color.secondaryColor,
                        validator: CustomTextFieldValidator.nullCheck,
                        action: TextInputAction.next,
                        hintText: "userName".translate(context),
                        borderColor: context.color.borderColor.darken(10),
                      ),
                      const SizedBox(height: 14),
                      if (UserType.provider == widget.userType) ...[
                        CustomTextFormField(
                          controller: _projectNameController,
                          fillColor: context.color.secondaryColor,
                          validator: CustomTextFieldValidator.nullCheck,
                          action: TextInputAction.next,
                          hintText:
                              "projectName_store_company".translate(context),
                          borderColor: context.color.borderColor.darken(10),
                        ),
                        const SizedBox(height: 14),
                        DropdownButtonFormField<CategoryModel>(
                          value: _tempSelectedCat,
                          validator: (val) => Validator.nullCheckValidator(
                            val?.name,
                            context: context,
                          ),
                          menuMaxHeight: 300.rh(context),
                          dropdownColor: context.color.secondaryColor,
                          icon: const Icon(Icons.keyboard_arrow_down_outlined),
                          hint: Text("chooseCategory".translate(context)),
                          elevation: 11,
                          decoration: InputDecoration(
                            fillColor: context.color.secondaryColor,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          borderRadius: BorderRadius.circular(5),
                          onChanged: (CategoryModel? newValue) {
                            setState(() {
                              _tempSelectedCat = newValue!;
                              _categoryController.text = newValue.id.toString();
                            });
                          },
                          items: categories
                              .map<DropdownMenuItem<CategoryModel>>(
                                  (CategoryModel value) {
                            return DropdownMenuItem<CategoryModel>(
                              value: value,
                              child: Text(value.name!),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 14),
                      ],
                      CustomTextFormField(
                        controller: _emailController,
                        fillColor: context.color.secondaryColor,
                        action: TextInputAction.next,
                        validator: CustomTextFieldValidator.email,
                        hintText: "emailAddress".translate(context),
                        keyboard: TextInputType.emailAddress,
                        borderColor: context.color.borderColor.darken(10),
                      ),
                      const SizedBox(height: 14),
                      CustomTextFormField(
                        controller: _passwordController,
                        fillColor: context.color.secondaryColor,
                        obscureText: isObscure,
                        suffix: IconButton(
                          onPressed: () {
                            isObscure = !isObscure;
                            setState(() {});
                          },
                          icon: Icon(
                            !isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: context.color.textColorDark.withOpacity(0.3),
                          ),
                        ),
                        hintText: "password".translate(context),
                        validator: CustomTextFieldValidator.password,
                        onEditingComplete: onTapSignup,
                        borderColor: context.color.borderColor.darken(10),
                      ),
                      const SizedBox(height: 36),
                      UiUtils.buildButton(context,
                          onPressed: onTapSignup,
                          buttonTitle: "verifyEmailAddress".translate(context),
                          radius: 10,
                          disabled: false,
                          height: 46,
                          disabledColor:
                              const Color.fromARGB(255, 104, 102, 106)),
                      const SizedBox(
                        height: 36,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("alreadyHaveAcc".translate(context))
                              .color(context.color.textColorDark.brighten(50)),
                          const SizedBox(
                            width: 12,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                Routes.login,
                                (route) => route.isFirst,
                              );
                            },
                            child: Text("login".translate(context))
                                .underline()
                                .color(context.color.territoryColor),
                          )
                        ],
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: Text("orSignInWith".translate(context))
                            .color(context.color.textDefaultColor)
                            .centerAlign(),
                      ),
                      const SizedBox(height: 24),
                      UiUtils.buildButton(context,
                          prefixWidget: Padding(
                            padding:
                                const EdgeInsetsDirectional.only(end: 10.0),
                            child: UiUtils.getSvg(
                              AppIcons.googleIcon,
                              width: 22,
                              height: 22,
                            ),
                          ),
                          showElevation: false,
                          buttonColor: secondaryColor_,
                          border:
                              context.watch<AppThemeCubit>().state.appTheme !=
                                      AppTheme.dark
                                  ? BorderSide(
                                      color: context.color.textDefaultColor
                                          .withOpacity(0.5),
                                    )
                                  : null,
                          textColor: textDarkColor, onPressed: () {
                        context.read<AuthenticationCubit>().setData(
                            payload: GoogleLoginPayload(),
                            type: AuthenticationType.google);
                        context.read<AuthenticationCubit>().authenticate();
                      },
                          radius: 8,
                          height: 46,
                          buttonTitle: "continueWithGoogle".translate(context)),
                      const SizedBox(height: 12),
                      if (Platform.isIOS)
                        UiUtils.buildButton(context,
                            prefixWidget: Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(end: 10.0),
                              child: UiUtils.getSvg(
                                AppIcons.appleIcon,
                                width: 22,
                                height: 22,
                              ),
                            ),
                            showElevation: false,
                            buttonColor: secondaryColor_,
                            border:
                                context.watch<AppThemeCubit>().state.appTheme !=
                                        AppTheme.dark
                                    ? BorderSide(
                                        color: context.color.textDefaultColor
                                            .withOpacity(0.5))
                                    : null,
                            textColor: textDarkColor, onPressed: () {
                          context.read<AuthenticationCubit>().setData(
                              payload: AppleLoginPayload(),
                              type: AuthenticationType.apple);
                          context.read<AuthenticationCubit>().authenticate();
                        },
                            height: 46,
                            radius: 8,
                            buttonTitle:
                                "continueWithApple".translate(context)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget termAndPolicyTxt() {
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
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            InkWell(
                child: Text("termsOfService".translate(context))
                    .underline()
                    .color(context.color.territoryColor)
                    .size(context.font.small),
                onTap: () => Navigator.pushNamed(
                        context, Routes.profileSettings, arguments: {
                      'title': "termsConditions".translate(context),
                      'param': Api.termsAndConditions
                    })),
            /*CustomTextButton(
                text:Text("termsOfService".translate(context)).underline().color(context.color.teritoryColor).size(context.font.small),
                onPressed: () => Navigator.pushNamed(
                        context, Routes.profileSettings,
                        arguments: {
                          'title': UiUtils.getTranslatedLabel(
                              context, "termsConditions"),
                          'param': Api.termsAndConditions
                        })),*/
            const SizedBox(
              width: 5.0,
            ),
            Text("andTxt".translate(context))
                .size(context.font.small)
                .color(context.color.textLightColor.withOpacity(0.8)),
            const SizedBox(
              width: 5.0,
            ),
            InkWell(
                child: Text("privacyPolicy".translate(context))
                    .underline()
                    .color(context.color.territoryColor)
                    .size(context.font.small),
                onTap: () => Navigator.pushNamed(
                        context, Routes.profileSettings, arguments: {
                      'title': "privacyPolicy".translate(context),
                      'param': Api.privacyPolicy
                    })),
          ]),
        ],
      ),
    );
  }
}
