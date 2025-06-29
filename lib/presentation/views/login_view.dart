import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:scan_canser_detection/controllers/auth/auth_cubit.dart';
import 'package:scan_canser_detection/core/constants/app_assets.dart';

import 'package:scan_canser_detection/core/localization/language/language_cubit.dart';
import 'package:scan_canser_detection/core/utils/router/app_router.dart';
import 'package:scan_canser_detection/core/widgets/custom_bottom.dart';
import 'package:scan_canser_detection/core/widgets/custom_text_filed.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LanguageCubit>().state;
    final isArabic = locale.languageCode == 'ar';

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          GoRouter.of(context)..pushReplacement(AppRouter.kHomeView);
        } else if (state is LoginError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Form(
          key: formKey,
          child: Scaffold(
            body: ModalProgressHUD(
              inAsyncCall: state is LoginLoading,
              progressIndicator: Lottie.asset(AppAssets.loding, height: 150),
              child: Padding(
                padding: const EdgeInsets.only(top: 75, left: 25, right: 25),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: isArabic
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                    children: [
                      Center(
                        child: Text(
                          isArabic ? "تسجيل الدخول" : "Log in",
                          style: const TextStyle(
                            fontSize: 24,
                            fontFamily: 'Bahnschrift',
                            color: Color(0xff00487C),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                      CustomTextFormField(
                        controller: emailController,
                        label: isArabic ? "البريد الإلكتروني" : "Email",
                        hintText: isArabic
                            ? "أدخل بريدك الإلكتروني"
                            : "Enter your email",
                        icon: Icons.email_outlined,
                      ),
                      const SizedBox(height: 25),
                      CustomTextFormField(
                        icon: Icons.lock_outline_rounded,
                        isVisible: true,
                        controller: passwordController,
                        label: isArabic ? "كلمة المرور" : "Password",
                        hintText:
                            isArabic ? "أدخل كلمة المرور" : "Enter a password",
                      ),
                      const SizedBox(height: 15),
                      InkWell(
                        onTap: () => GoRouter.of(context)
                            .push(AppRouter.kForgetPassword),
                        child: Text(
                          isArabic ? "نسيت كلمة المرور؟" : "Forget Password?",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Bahnschrift',
                          ),
                        ),
                      ),
                      const SizedBox(height: 75),
                      CustomBottom(
                        text: isArabic ? "تسجيل الدخول" : "Log in",
                        ontap: () {
                          if (formKey.currentState?.validate() ?? false) {
                            context.read<AuthCubit>().login(
                                email: emailController.text,
                                password: passwordController.text);
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isArabic
                                ? "لا تملك حساب؟"
                                : "Don't have an account?",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'Bahnschrift',
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              GoRouter.of(context)
                                  .pushReplacement(AppRouter.kSignUp);
                            },
                            child: Text(
                              isArabic ? "إنشاء حساب" : "Sign up",
                              style: const TextStyle(
                                color: Color(0xff00487C),
                                fontSize: 14,
                                fontFamily: 'Bahnschrift',
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
