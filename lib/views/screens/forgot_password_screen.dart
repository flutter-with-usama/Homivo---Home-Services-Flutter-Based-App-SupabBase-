import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';
import '../../data/repositories/auth_repository.dart';
import '../widgets/auth/app_primary_button.dart';
import '../widgets/auth/app_text_field.dart';
import 'otp_verify_screen.dart';

/// Step 1 — user enters their email to receive a 6-digit OTP.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  final _repo      = AuthRepository();

  bool    _isLoading    = false;
  String? _errorMessage;
  String  _email        = '';

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    final email = _email.trim();
    if (email.isEmpty) {
      setState(() => _errorMessage = 'Please enter your email address.');
      return;
    }

    setState(() {
      _isLoading    = true;
      _errorMessage = null;
    });

    final result = await _repo.sendPasswordResetOtp(email);

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (result.success) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpVerifyScreen(email: email),
        ),
      );
    } else {
      setState(() => _errorMessage = result.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _AppBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),

              // ── Icon ────────────────────────────────────────────────────
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_reset_rounded,
                    color: AppTheme.primary,
                    size: 38,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ── Heading ──────────────────────────────────────────────────
              const Text(
                'Forgot Password?',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter your registered email address and we will send you a 6-digit verification code.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textGrey,
                  height: 1.55,
                ),
              ),

              const SizedBox(height: 32),

              // ── Email field ──────────────────────────────────────────────
              AppTextField(
                hint: 'Email address',
                controller: _emailCtrl,
                onChanged: (v) {
                  _email = v;
                  if (_errorMessage != null) {
                    setState(() => _errorMessage = null);
                  }
                },
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                autofocus: true,
              ),

              // ── Error banner ─────────────────────────────────────────────
              if (_errorMessage != null) ...[
                const SizedBox(height: 10),
                _ErrorBanner(message: _errorMessage!),
              ],

              const SizedBox(height: 28),

              // ── Send Code button ─────────────────────────────────────────
              AppPrimaryButton(
                label: 'SEND CODE',
                isLoading: _isLoading,
                onTap: _email.trim().isNotEmpty ? _sendOtp : null,
              ),

              const SizedBox(height: 24),

              // ── Back to login ────────────────────────────────────────────
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: RichText(
                    text: const TextSpan(
                      text: 'Remember your password?  ',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textGrey,
                      ),
                      children: [
                        TextSpan(
                          text: 'Log In',
                          style: TextStyle(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE8E8E8), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: Color(0xFF1A1A2E),
            ),
          ),
        ),
      ),
      title: const Text(
        'Reset Password',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1A1A2E),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: const Color(0xFFF0F0F0)),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              color: Color(0xFFEF4444), size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFFEF4444),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
