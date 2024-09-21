import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eClassify/Ui/screens/Widgets/AnimatedRoutes/blur_page_route.dart';
import 'package:eClassify/Ui/screens/Widgets/custom_text_form_field.dart';
import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:eClassify/Utils/Login/lib/payloads.dart';
import 'package:eClassify/Utils/cloudState/cloud_state.dart';
import 'package:eClassify/Utils/helper_utils.dart';
import 'package:eClassify/Utils/responsiveSize.dart';
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
import 'login_screen.dart';
import 'widgets/sign_up/sign_up_categories_drop_down_button.dart';
import 'widgets/sign_up/sign_up_text_field.dart';
import 'widgets/sign_up/term_and_policy_txt.dart';

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
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isObscure = true;
  bool isRePassObscure = true;
  bool catHasError = false;

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
    _mobileController.dispose();
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

  void checkCatValidation() {
    if (_categoryController.text.isEmpty) {
      catHasError = true;
    } else {
      catHasError = false;
    }
    setState(() {});
  }

  void onTapSignup() async {
    checkCatValidation();
    if ((_formKey.currentState?.validate() ?? false) && !catHasError) {
      final Map<String, String> map = {};
      map[Api.type] = AuthenticationType.email.name;
      map[Api.email] = _emailController.text.trim();
      map[Api.mobile] = _mobileController.text.trim();
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
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18, top: 23),
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
                    const SizedBox(height: 40),
                    Align(
                      child: Column(
                        children: [
                          SizedBox.square(
                            dimension: 180.rw(context),
                            child: UiUtils.getSvg(AppIcons.splashLogo),
                          ),
                          const SizedBox(height: 20),
                          Text("signUp".translate(context).toUpperCase())
                              .size(32)
                              .bold(weight: FontWeight.w700)
                              .centerAlign(),
                          Container(
                            margin: const EdgeInsets.all(20),
                            padding: const EdgeInsets.all(20),
                            constraints: BoxConstraints(
                              maxWidth: 350.rh(context),
                            ),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xffCAC8C8)),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  SignUpTextField(
                                    controller: _usernameController,
                                    hintText: "userName".translate(context),
                                    validator:
                                        CustomTextFieldValidator.nullCheck,
                                  ),
                                  const SizedBox(height: 14),
                                  if (UserType.provider == widget.userType) ...[
                                    SignUpTextField(
                                      controller: _projectNameController,
                                      hintText: "projectName_store_company"
                                          .translate(context),
                                      validator:
                                          CustomTextFieldValidator.nullCheck,
                                    ),
                                    const SizedBox(height: 14),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SignUpCategoriesDropDownButton(
                                          isError: catHasError,
                                          categories: categories,
                                          onChanged: (newValue) {
                                            _categoryController.text =
                                                newValue.id.toString();
                                          },
                                        ),
                                        if (catHasError)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 10,
                                            ),
                                            child: Text(
                                              "fieldMustNotBeEmpty"
                                                  .translate(context),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: context.color.error,
                                              ),
                                            ),
                                          )
                                      ],
                                    ),
                                    const SizedBox(height: 14),
                                  ],
                                  SignUpTextField(
                                    controller: _emailController,
                                    hintText: "emailAddress".translate(context),
                                    validator: CustomTextFieldValidator.email,
                                    keyboard: TextInputType.emailAddress,
                                  ),
                                  const SizedBox(height: 14),
                                  SignUpTextField(
                                    controller: _mobileController,
                                    hintText: "phoneNumber".translate(context),
                                    validator:
                                        CustomTextFieldValidator.phoneNumber,
                                    keyboard: TextInputType.number,
                                    formaters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  SignUpTextField(
                                    obscureText: isObscure,
                                    hintText: "password".translate(context),
                                    validator:
                                        CustomTextFieldValidator.password,
                                    controller: _passwordController,
                                    formaters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    suffix: IconButton(
                                      onPressed: () {
                                        isObscure = !isObscure;
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        !isObscure
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: context.color.textColorDark
                                            .withOpacity(0.3),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  SignUpTextField(
                                    obscureText: isRePassObscure,
                                    suffix: IconButton(
                                      onPressed: () {
                                        isRePassObscure = !isRePassObscure;
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        !isRePassObscure
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: context.color.textColorDark
                                            .withOpacity(0.3),
                                      ),
                                    ),
                                    hintText:
                                        "confirmPassword".translate(context),
                                    customValidatorFn: (val) {
                                      if (val?.isNotEmpty != true) {
                                        return "fieldMustNotBeEmpty"
                                            .translate(context);
                                      } else if (_passwordController.text !=
                                          val) {
                                        return "passwordsNotMatch"
                                            .translate(context);
                                      }
                                      return null;
                                    },
                                    onEditingComplete: onTapSignup,
                                  ),
                                  const SizedBox(height: 36),
                                  UiUtils.buildButton(context,
                                      onPressed: onTapSignup,
                                      buttonTitle: "signUp".translate(context),
                                      radius: 10,
                                      disabled: false,
                                      height: 46,
                                      disabledColor: const Color.fromARGB(
                                          255, 104, 102, 106)),
                                  const SizedBox(height: 36),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("alreadyHaveAcc".translate(context))
                                          .color(context.color.textColorDark
                                              .brighten(50)),
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
                                            .color(
                                                context.color.territoryColor),
                                      )
                                    ],
                                  ),
                                  if (showLoginWithGoogle ||
                                      showLoginWithApple) ...[
                                    const SizedBox(height: 24),
                                    Center(
                                      child: Text(
                                              "orSignInWith".translate(context))
                                          .color(context.color.textDefaultColor)
                                          .centerAlign(),
                                    ),
                                  ],
                                  if (showLoginWithGoogle) ...[
                                    const SizedBox(height: 24),
                                    UiUtils.buildButton(context,
                                        prefixWidget: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  end: 10.0),
                                          child: UiUtils.getSvg(
                                            AppIcons.googleIcon,
                                            width: 22,
                                            height: 22,
                                          ),
                                        ),
                                        showElevation: false,
                                        buttonColor: secondaryColor_,
                                        border: context
                                                    .watch<AppThemeCubit>()
                                                    .state
                                                    .appTheme !=
                                                AppTheme.dark
                                            ? BorderSide(
                                                color: context
                                                    .color.textDefaultColor
                                                    .withOpacity(0.5),
                                              )
                                            : null,
                                        textColor: textDarkColor,
                                        onPressed: () {
                                      context
                                          .read<AuthenticationCubit>()
                                          .setData(
                                              payload: GoogleLoginPayload(),
                                              type: AuthenticationType.google);
                                      context
                                          .read<AuthenticationCubit>()
                                          .authenticate();
                                    },
                                        radius: 8,
                                        height: 46,
                                        buttonTitle: "continueWithGoogle"
                                            .translate(context)),
                                  ],
                                  const SizedBox(height: 12),
                                  if (Platform.isIOS && showLoginWithApple)
                                    UiUtils.buildButton(
                                      context,
                                      prefixWidget: Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                end: 10.0),
                                        child: UiUtils.getSvg(
                                          AppIcons.appleIcon,
                                          width: 22,
                                          height: 22,
                                        ),
                                      ),
                                      showElevation: false,
                                      buttonColor: secondaryColor_,
                                      border: context
                                                  .watch<AppThemeCubit>()
                                                  .state
                                                  .appTheme !=
                                              AppTheme.dark
                                          ? BorderSide(
                                              color: context
                                                  .color.textDefaultColor
                                                  .withOpacity(0.5))
                                          : null,
                                      textColor: textDarkColor,
                                      onPressed: () {
                                        context
                                            .read<AuthenticationCubit>()
                                            .setData(
                                                payload: AppleLoginPayload(),
                                                type: AuthenticationType.apple);
                                        context
                                            .read<AuthenticationCubit>()
                                            .authenticate();
                                      },
                                      height: 46,
                                      radius: 8,
                                      buttonTitle: "continueWithApple"
                                          .translate(context),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const TermAndPolicyTxt(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
