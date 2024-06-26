import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/login/login.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      resizeToAvoidBottomInset: true,
      releaseFocus: true,
      body: AppConstrainedScrollView(
        child: Column(
          children: [
            const WelcomeImage(),
            const SizedBox(height: AppSpacing.lg),
            const LoginForm(),
            const SizedBox(height: AppSpacing.md),
            const Spacer(),
            LoginFooter(
              text: 'Sign up',
              onTap: () {
                context.read<LoginCubit>().reset();
                context.pushReplacementNamed(AppRoutes.signUp.name);
              },
            ),
          ],
        ),
      ),
    );
  }
}
