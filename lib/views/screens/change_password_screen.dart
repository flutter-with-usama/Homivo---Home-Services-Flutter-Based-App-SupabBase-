import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';
import '../../viewmodels/change_password_viewmodel.dart';
import '../widgets/change_password/change_password_field.dart';
import '../widgets/change_password/change_password_rule_row.dart';
import '../widgets/change_password/password_strength_bar.dart';

/// Change Password screen — shared by both client and provider profiles.
///
/// Pass [accentColor] to brand it:
///   • Client   → AppTheme.primary   (green)
///   • Provider → AppTheme.deepPurple (purple)
///
/// The user must enter their current password to verify identity,
/// then set a new password that meets the strength rules.
class ChangePasswordScreen extends StatefulWidget {
  /// Brand colour — green for client, deep purple for provider.
  final Color accentColor;

  const ChangePasswordScreen({super.key, this.accentColor = AppTheme.primary});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late final ChangePasswordViewModel _vm;

  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _vm = ChangePasswordViewModel();
    _vm.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _vm.dispose();
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    final success = await _vm.save();
    if (!mounted) return;
    if (success) {
      await _showSuccessDialog();
      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }

  Future<void> _showSuccessDialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Success icon ─────────────────────────────────────────
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: widget.accentColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_open_rounded,
                color: widget.accentColor,
                size: 34,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Password Changed!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your password has been updated successfully. Use your new password next time you log in.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.textGrey,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            // ── Done button ──────────────────────────────────────────
            GestureDetector(
              onTap: () => Navigator.of(dialogContext).pop(),
              child: Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.accentColor,
                      widget.accentColor.withValues(alpha: 0.80),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: widget.accentColor.withValues(alpha: 0.30),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Done',
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
    final accent = widget.accentColor;

    return Scaffold(
      backgroundColor: AppTheme.bgPage,

      // ── App bar ──────────────────────────────────────────────────────────
      appBar: _ChangePasswordAppBar(
        accentColor: accent,
        canSave: _vm.canSave && !_vm.isLoading,
        isLoading: _vm.isLoading,
        onSave: _save,
      ),

      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 1. Header icon + description ───────────────────────────
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lock_outline_rounded,
                        color: accent,
                        size: 34,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Change Password',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Enter your current password to verify\nyour identity, then set a new one.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textGrey,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ── 2. Current password ────────────────────────────────────
              _SectionLabel(label: 'Current Password', color: accent),
              const SizedBox(height: 12),

              ChangePasswordField(
                label: 'Current Password',
                hint: 'Enter your current password',
                controller: _currentCtrl,
                onChanged: _vm.onCurrentChanged,
                obscureText: _vm.obscureCurrent,
                onToggleObscure: _vm.toggleCurrent,
                accentColor: accent,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 24),

              // ── 3. New password ────────────────────────────────────────
              _SectionLabel(label: 'New Password', color: accent),
              const SizedBox(height: 12),

              ChangePasswordField(
                label: 'New Password',
                hint: 'Enter new password',
                controller: _newCtrl,
                onChanged: _vm.onNewPassChanged,
                obscureText: _vm.obscureNew,
                onToggleObscure: _vm.toggleNew,
                accentColor: accent,
                textInputAction: TextInputAction.next,
              ),

              // ── Strength bar ─────────────────────────────────────────
              if (_vm.newPass.isNotEmpty) ...[
                const SizedBox(height: 10),
                PasswordStrengthBar(password: _vm.newPass, accentColor: accent),
              ],

              const SizedBox(height: 16),

              ChangePasswordField(
                label: 'Confirm New Password',
                hint: 'Re-enter new password',
                controller: _confirmCtrl,
                onChanged: _vm.onConfirmChanged,
                obscureText: _vm.obscureConfirm,
                onToggleObscure: _vm.toggleConfirm,
                accentColor: accent,
                textInputAction: TextInputAction.done,
                errorText: _vm.showMismatch ? 'Passwords do not match' : null,
              ),

              // ── 4. Password rules ──────────────────────────────────────
              if (_vm.newPass.isNotEmpty) ...[
                const SizedBox(height: 20),
                _SectionLabel(label: 'Password Requirements', color: accent),
                const SizedBox(height: 10),
                ChangePasswordRuleRow(
                  label: 'At least 8 characters',
                  passed: _vm.ruleMinLength,
                  accentColor: accent,
                ),
                ChangePasswordRuleRow(
                  label: 'At least one uppercase letter (A–Z)',
                  passed: _vm.ruleUppercase,
                  accentColor: accent,
                ),
                ChangePasswordRuleRow(
                  label: 'At least one number (0–9)',
                  passed: _vm.ruleNumber,
                  accentColor: accent,
                ),
                ChangePasswordRuleRow(
                  label: 'At least one special character (!@#\$...)',
                  passed: _vm.ruleSpecial,
                  accentColor: accent,
                ),
                ChangePasswordRuleRow(
                  label: 'New and confirm passwords match',
                  passed: _vm.ruleMatch,
                  accentColor: accent,
                ),
              ],

              const SizedBox(height: 28),

              // ── 5. Error banner ────────────────────────────────────────
              if (_vm.errorMessage != null) ...[
                _ErrorBanner(message: _vm.errorMessage!),
                const SizedBox(height: 16),
              ],

              // ── 6. Save button ─────────────────────────────────────────
              _SaveButton(
                isLoading: _vm.isLoading,
                canSave: _vm.canSave,
                accentColor: accent,
                onTap: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── App bar ───────────────────────────────────────────────────────────────────
class _ChangePasswordAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final Color accentColor;
  final bool canSave;
  final bool isLoading;
  final VoidCallback onSave;

  const _ChangePasswordAppBar({
    required this.accentColor,
    required this.canSave,
    required this.isLoading,
    required this.onSave,
  });

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
        'Change Password',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1A1A2E),
        ),
      ),
      // Quick-save in app bar
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: canSave ? onSave : null,
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                      ),
                    )
                  : Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: canSave ? accentColor : AppTheme.textGrey,
                      ),
                    ),
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: const Color(0xFFF0F0F0)),
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  final Color color;
  const _SectionLabel({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A2E),
          ),
        ),
      ],
    );
  }
}

// ── Save button ───────────────────────────────────────────────────────────────
class _SaveButton extends StatelessWidget {
  final bool isLoading;
  final bool canSave;
  final Color accentColor;
  final VoidCallback onTap;

  const _SaveButton({
    required this.isLoading,
    required this.canSave,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: canSave && !isLoading ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          gradient: canSave
              ? LinearGradient(
                  colors: [accentColor, accentColor.withValues(alpha: 0.80)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: canSave ? null : const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(14),
          boxShadow: canSave
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  'Update Password',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: canSave ? Colors.white : AppTheme.textGrey,
                    letterSpacing: 0.3,
                  ),
                ),
        ),
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
          const Icon(
            Icons.error_outline_rounded,
            color: Color(0xFFEF4444),
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 12, color: Color(0xFFEF4444)),
            ),
          ),
        ],
      ),
    );
  }
}
