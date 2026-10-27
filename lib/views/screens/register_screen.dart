import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/register_model.dart';
import '../../viewmodels/register_viewmodel.dart';
import '../widgets/auth/auth_app_bar.dart';
import '../widgets/auth/auth_header.dart';
import '../widgets/auth/app_text_field.dart';
import '../widgets/auth/app_primary_button.dart';
import '../widgets/auth/terms_condition_text.dart';
import '../widgets/auth/already_have_account_row.dart';

class RegisterScreen extends StatefulWidget {
  final UserRole role;

  const RegisterScreen({super.key, required this.role});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final RegisterViewModel _vm;

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _specialtyCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Create a local VM pre-seeded with the chosen role
    _vm = RegisterViewModel(role: widget.role);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _passwordCtrl.dispose();
    _specialtyCtrl.dispose();
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegisterViewModel>.value(
      value: _vm,
      child: Consumer<RegisterViewModel>(
        builder: (context, vm, _) {
          final isProvider = vm.isProvider;
          final accentColor = isProvider
              ? AppTheme.deepPurple
              : AppTheme.primary;

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AuthAppBar(
              title: isProvider ? 'Provider Sign Up' : 'Client Sign Up',
            ),
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // ── Role badge ─────────────────────────────────────────
                    _RoleBadge(
                      isProvider: isProvider,
                      accentColor: accentColor,
                    ),

                    const SizedBox(height: 20),

                    // ── Header ─────────────────────────────────────────────
                    AuthHeader(
                      title: isProvider
                          ? 'Create Provider Account'
                          : 'Create an Account',
                      subtitle: isProvider
                          ? 'Fill in your details to start receiving jobs'
                          : 'Please fill registration form below',
                    ),

                    const SizedBox(height: 24),

                    // ── Full name ──────────────────────────────────────────
                    AppTextField(
                      hint: 'Full name',
                      controller: _nameCtrl,
                      onChanged: vm.onFullNameChanged,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      autofocus: true,
                    ),

                    const SizedBox(height: 14),

                    // ── Email ──────────────────────────────────────────────
                    AppTextField(
                      hint: 'Email address',
                      controller: _emailCtrl,
                      onChanged: vm.onEmailChanged,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),

                    const SizedBox(height: 14),

                    // ── Phone ──────────────────────────────────────────────
                    AppTextField(
                      hint: 'Phone number',
                      controller: _phoneCtrl,
                      onChanged: vm.onPhoneChanged,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                    ),

                    const SizedBox(height: 14),

                    // ── Address ────────────────────────────────────────────
                    AppTextField(
                      hint: isProvider ? 'City' : 'Address',
                      controller: _addressCtrl,
                      onChanged: vm.onAddressChanged,
                      obscureText: vm.isAddressObscured,
                      onToggleObscure: vm.toggleAddressVisibility,
                      keyboardType: TextInputType.streetAddress,
                      textInputAction: TextInputAction.next,
                    ),

                    // ── Provider-only: Specialty ───────────────────────────
                    if (isProvider) ...[
                      const SizedBox(height: 14),
                      _SpecialtyPicker(
                        selected: vm.specialty,
                        accentColor: accentColor,
                        onChanged: vm.onSpecialtyChanged,
                      ),
                    ],

                    const SizedBox(height: 14),

                    // ── Password ───────────────────────────────────────────
                    AppTextField(
                      hint: 'Password',
                      controller: _passwordCtrl,
                      onChanged: vm.onPasswordChanged,
                      obscureText: vm.isPasswordObscured,
                      onToggleObscure: vm.togglePasswordVisibility,
                      textInputAction: TextInputAction.done,
                    ),

                    const SizedBox(height: 24),

                    // ── Submit button ──────────────────────────────────────
                    AppPrimaryButton(
                      label: isProvider
                          ? 'CREATE PROVIDER ACCOUNT'
                          : 'CREATE ACCOUNT',
                      isLoading: vm.isLoading,
                      onTap: vm.canSubmit
                          ? () async {
                              final success = await vm.register();
                              if (context.mounted && success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isProvider
                                          ? 'Provider account created! Check your email.'
                                          : 'Account created! Check your email.',
                                    ),
                                    backgroundColor: accentColor,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/login',
                                );
                              }
                            }
                          : null,
                    ),

                    // ── Error banner ───────────────────────────────────────
                    if (vm.errorMessage != null) ...[
                      const SizedBox(height: 10),
                      _ErrorBanner(message: vm.errorMessage!),
                    ],

                    const SizedBox(height: 16),

                    Center(
                      child: TermsConditionText(
                        onTerms: () {},
                        onCondition: () {},
                      ),
                    ),

                    const SizedBox(height: 24),

                    AlreadyHaveAccountRow(
                      onLogin: () =>
                          Navigator.pushReplacementNamed(context, '/login'),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Role badge ────────────────────────────────────────────────────────────────
class _RoleBadge extends StatelessWidget {
  final bool isProvider;
  final Color accentColor;

  const _RoleBadge({required this.isProvider, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.30),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isProvider ? Icons.handyman_rounded : Icons.home_rounded,
            color: accentColor,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            isProvider ? 'Signing up as Provider' : 'Signing up as Client',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: accentColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Specialty picker (provider only) ─────────────────────────────────────────
class _SpecialtyPicker extends StatelessWidget {
  final String selected;
  final Color accentColor;
  final ValueChanged<String> onChanged;

  static const _specialties = [
    'Plumbing',
    'Electrical',
    'Carpentry',
    'Cleaning',
    'Appliance Repair',
    'Painting',
    'Landscaping',
    'Pest Control',
    'HVAC',
    'Roofing',
  ];

  const _SpecialtyPicker({
    required this.selected,
    required this.accentColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Service',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: accentColor,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _specialties.map((s) {
            final isSelected = s == selected;
            return GestureDetector(
              onTap: () => onChanged(s),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? accentColor : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? accentColor : const Color(0xFFE0E0E0),
                    width: 1.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: accentColor.withValues(alpha: 0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  s,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppTheme.textGrey,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
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
