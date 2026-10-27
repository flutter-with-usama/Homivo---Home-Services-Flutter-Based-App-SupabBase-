import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';
import '../../data/repositories/auth_repository.dart';
import '../widgets/auth/app_primary_button.dart';
import '../widgets/auth/app_text_field.dart';

/// Step 2 — user enters the 6-digit OTP from email + sets a new password.
class OtpVerifyScreen extends StatefulWidget {
  final String email;

  const OtpVerifyScreen({super.key, required this.email});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  // ── OTP boxes ──────────────────────────────────────────────────────────────
  final List<TextEditingController> _otpCtrls =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(6, (_) => FocusNode());

  // ── New password ───────────────────────────────────────────────────────────
  final _passwordCtrl    = TextEditingController();
  final _confirmCtrl     = TextEditingController();
  bool  _obscurePassword = true;
  bool  _obscureConfirm  = true;

  final _repo = AuthRepository();

  bool    _isLoading    = false;
  String? _errorMessage;
  bool    _isResending  = false;

  @override
  void dispose() {
    for (final c in _otpCtrls) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  String get _otp => _otpCtrls.map((c) => c.text).join();

  bool get _canSubmit =>
      _otp.length == 6 &&
      _passwordCtrl.text.length >= 6 &&
      _passwordCtrl.text == _confirmCtrl.text;

  Future<void> _verify() async {
    if (!_canSubmit) return;

    if (_passwordCtrl.text != _confirmCtrl.text) {
      setState(() => _errorMessage = 'Passwords do not match.');
      return;
    }

    setState(() {
      _isLoading    = true;
      _errorMessage = null;
    });

    final result = await _repo.verifyOtpAndResetPassword(
      email:       widget.email,
      otp:         _otp,
      newPassword: _passwordCtrl.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success) {
      _showSuccess();
    } else {
      setState(() => _errorMessage = result.errorMessage);
    }
  }

  Future<void> _resendCode() async {
    setState(() => _isResending = true);
    await _repo.sendPasswordResetOtp(widget.email);
    if (!mounted) return;
    setState(() => _isResending = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('A new code has been sent to your email.'),
        backgroundColor: AppTheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppTheme.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded,
                  color: AppTheme.primary, size: 34),
            ),
            const SizedBox(height: 16),
            const Text(
              'Password Updated!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your password has been reset successfully. Please log in with your new password.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.textGrey,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // close dialog
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primary, AppTheme.primaryDark],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'Go to Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
              const SizedBox(height: 28),

              // ── Heading ────────────────────────────────────────────────
              const Text(
                'Enter Verification Code',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textGrey,
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(text: 'We sent a 6-digit code to\n'),
                    TextSpan(
                      text: widget.email,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ── OTP boxes ──────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (i) => _OtpBox(
                  controller: _otpCtrls[i],
                  focusNode:  _focusNodes[i],
                  onChanged: (val) {
                    if (val.isNotEmpty && i < 5) {
                      _focusNodes[i + 1].requestFocus();
                    } else if (val.isEmpty && i > 0) {
                      _focusNodes[i - 1].requestFocus();
                    }
                    setState(() {});
                  },
                )),
              ),

              const SizedBox(height: 10),

              // ── Resend ─────────────────────────────────────────────────
              Center(
                child: GestureDetector(
                  onTap: _isResending ? null : _resendCode,
                  child: Text(
                    _isResending ? 'Sending...' : 'Resend Code',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ── New password ───────────────────────────────────────────
              const Text(
                'New Password',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 8),
              AppTextField(
                hint: 'New password (min 6 characters)',
                controller: _passwordCtrl,
                obscureText: _obscurePassword,
                onToggleObscure: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                onChanged: (_) => setState(() {}),
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 14),

              const Text(
                'Confirm Password',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 8),
              AppTextField(
                hint: 'Confirm new password',
                controller: _confirmCtrl,
                obscureText: _obscureConfirm,
                onToggleObscure: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
                onChanged: (_) => setState(() {}),
                textInputAction: TextInputAction.done,
              ),

              // ── Password mismatch hint ─────────────────────────────────
              if (_confirmCtrl.text.isNotEmpty &&
                  _passwordCtrl.text != _confirmCtrl.text) ...[
                const SizedBox(height: 6),
                const Padding(
                  padding: EdgeInsets.only(left: 14),
                  child: Text(
                    'Passwords do not match',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                ),
              ],

              // ── Error banner ───────────────────────────────────────────
              if (_errorMessage != null) ...[
                const SizedBox(height: 10),
                _ErrorBanner(message: _errorMessage!),
              ],

              const SizedBox(height: 28),

              // ── Confirm button ─────────────────────────────────────────
              AppPrimaryButton(
                label: 'RESET PASSWORD',
                isLoading: _isLoading,
                onTap: _canSubmit ? _verify : null,
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Single OTP digit box ──────────────────────────────────────────────────────
class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filled = controller.text.isNotEmpty;
    return SizedBox(
      width: 46,
      height: 54,
      child: TextField(
        controller:    controller,
        focusNode:     focusNode,
        onChanged:     onChanged,
        textAlign:     TextAlign.center,
        maxLength:     1,
        keyboardType:  TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1A1A2E),
        ),
        decoration: InputDecoration(
          counterText: '',
          filled:      true,
          fillColor:   filled ? AppTheme.primaryLight : const Color(0xFFF6F8FA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: filled ? AppTheme.primary : const Color(0xFFE0E0E0),
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: filled ? AppTheme.primary : const Color(0xFFE0E0E0),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppTheme.primary,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

// ── App bar ───────────────────────────────────────────────────────────────────
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
        'Verify Code',
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

// ── Error banner ──────────────────────────────────────────────────────────────
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
