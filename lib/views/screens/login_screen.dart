import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/login_viewmodel.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../../data/models/register_model.dart';
import '../widgets/auth/auth_app_bar.dart';
import '../widgets/auth/auth_header.dart';
import '../widgets/auth/app_text_field.dart';
import '../widgets/auth/app_primary_button.dart';
import '../widgets/auth/app_outline_button.dart';
import '../widgets/auth/forgot_password_row.dart';
import '../widgets/auth/social_sign_in_row.dart';

/// Login screen — assembles all auth components.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AuthAppBar(title: 'User'),
      body: GestureDetector(
        // Dismiss keyboard on tap outside
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),

              // ── 1. Header ──────────────────────────────────────────────
              const AuthHeader(
                title: 'Log In',
                subtitle: 'Please log in to your registered account',
              ),

              const SizedBox(height: 32),

              // ── 2. Email field ─────────────────────────────────────────
              AppTextField(
                hint: 'Email or username',
                controller: _emailCtrl,
                onChanged: vm.onEmailChanged,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofocus: true,
              ),

              const SizedBox(height: 16),

              // ── 3. Password field ──────────────────────────────────────
              AppTextField(
                hint: 'Password',
                controller: _passwordCtrl,
                onChanged: vm.onPasswordChanged,
                obscureText: vm.isPasswordObscured,
                onToggleObscure: vm.togglePasswordVisibility,
                textInputAction: TextInputAction.done,
              ),

              const SizedBox(height: 24),

              // ── 4. LOG IN button ───────────────────────────────────────
              AppPrimaryButton(
                label: 'LOG IN',
                isLoading: vm.isLoading,
                onTap: vm.canSubmit
                    ? () async {
                        final role = await vm.login();
                        if (!context.mounted) return;
                        if (role != null) {
                          await _openDashboard(role);
                        }
                      }
                    : null,
              ),

              // ── Error message ──────────────────────────────────────────
              if (vm.errorMessage != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: Color(0xFFEF4444),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          vm.errorMessage!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFEF4444),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // ── 5. Forgot password ─────────────────────────────────────
              const ForgotPasswordRow(),

              const SizedBox(height: 32),

              // ── 6. Social sign-in ──────────────────────────────────────
              SocialSignInRow(
                onGoogle: () async {
                  final role = await vm.loginWithGoogle();
                  if (!context.mounted) return;
                  if (role != null) {
                    await _openDashboard(role);
                  }
                },
              ),

              const SizedBox(height: 32),

              // ── 7. CREATE ACCOUNT button ───────────────────────────────
              AppOutlineButton(
                label: 'CREATE ACCOUNT',
                onTap: () => Navigator.pushNamed(context, '/role-select'),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openDashboard(UserRole role) async {
    if (role == UserRole.client) {
      await context.read<HomeViewModel>().loadProfile();
    }
    if (!mounted) return;

    Navigator.pushReplacementNamed(context, switch (role) {
      UserRole.provider => '/provider-home',
      UserRole.admin => '/admin',
      UserRole.client => '/home',
    });
  }
}
