import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/register_model.dart';
import '../../viewmodels/edit_profile_viewmodel.dart';
import '../widgets/edit_profile/edit_profile_avatar.dart';
import '../widgets/edit_profile/edit_profile_field.dart';

/// Edit Profile screen — pre-filled with registration data.
/// Role-aware: shows Specialty picker for providers.
class EditProfileScreen extends StatefulWidget {
  final UserRole role;
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String specialty;
  final String initials;

  const EditProfileScreen({
    super.key,
    required this.role,
    required this.fullName,
    required this.email,
    required this.phone,
    this.address = '',
    this.specialty = '',
    required this.initials,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final EditProfileViewModel _vm;

  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _addressCtrl;

  @override
  void initState() {
    super.initState();
    _vm = EditProfileViewModel(
      role: widget.role,
      fullName: widget.fullName,
      email: widget.email,
      phone: widget.phone,
      address: widget.address,
      specialty: widget.specialty,
    );
    _vm.addListener(() => setState(() {}));

    _nameCtrl = TextEditingController(text: widget.fullName);
    _emailCtrl = TextEditingController(text: widget.email);
    _phoneCtrl = TextEditingController(text: widget.phone);
    _addressCtrl = TextEditingController(text: widget.address);
  }

  @override
  void dispose() {
    _vm.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    final success = await _vm.save();
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully! ✅'),
          backgroundColor: AppTheme.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context, true); // return true = profile was updated
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    final accentColor = _vm.isProvider ? AppTheme.deepPurple : AppTheme.primary;

    return Scaffold(
      backgroundColor: AppTheme.bgPage,

      // ── App bar ──────────────────────────────────────────────────────────
      appBar: _EditAppBar(
        isProvider: _vm.isProvider,
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
              // ── 1. Avatar ────────────────────────────────────────────
              Center(
                child: EditProfileAvatar(
                  initials: widget.initials,
                  isProvider: _vm.isProvider,
                ),
              ),

              const SizedBox(height: 32),

              // ── 2. Personal Information section ──────────────────────
              _SectionLabel(label: 'Personal Information', color: accentColor),
              const SizedBox(height: 14),

              // Full name
              EditProfileField(
                label: 'Full Name',
                hint: 'Enter your full name',
                controller: _nameCtrl,
                onChanged: _vm.onFullNameChanged,
                prefixIcon: Icons.person_outline_rounded,
                iconColor: accentColor,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 16),

              // Email — read-only
              EditProfileField(
                label: 'Email Address',
                hint: 'Email address',
                controller: _emailCtrl,
                onChanged: _vm.onEmailChanged,
                prefixIcon: Icons.email_outlined,
                iconColor: AppTheme.textGrey,
                keyboardType: TextInputType.emailAddress,
                readOnly: true,
                helperText: 'Email cannot be changed after registration.',
              ),

              const SizedBox(height: 16),

              // Phone
              EditProfileField(
                label: 'Phone Number',
                hint: 'Enter your phone number',
                controller: _phoneCtrl,
                onChanged: _vm.onPhoneChanged,
                prefixIcon: Icons.phone_outlined,
                iconColor: accentColor,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 16),

              // Address / City
              EditProfileField(
                label: _vm.isProvider ? 'City' : 'Address',
                hint: _vm.isProvider
                    ? 'Enter your city'
                    : 'Enter your home address',
                controller: _addressCtrl,
                onChanged: _vm.onAddressChanged,
                prefixIcon: Icons.location_on_outlined,
                iconColor: accentColor,
                keyboardType: TextInputType.streetAddress,
                textInputAction: _vm.isProvider
                    ? TextInputAction.next
                    : TextInputAction.done,
              ),

              // ── 3. Provider-only: Specialty ───────────────────────────
              if (_vm.isProvider) ...[
                const SizedBox(height: 24),
                _SectionLabel(label: 'Service Information', color: accentColor),
                const SizedBox(height: 12),
                _SpecialtyPicker(
                  selected: _vm.specialty,
                  accentColor: accentColor,
                  onChanged: _vm.onSpecialtyChanged,
                ),
              ],

              const SizedBox(height: 32),

              // ── 4. Error banner ───────────────────────────────────────
              if (_vm.errorMessage != null) ...[
                _ErrorBanner(message: _vm.errorMessage!),
                const SizedBox(height: 16),
              ],

              // ── 5. Save button ────────────────────────────────────────
              _SaveButton(
                isLoading: _vm.isLoading,
                canSave: _vm.canSave,
                accentColor: accentColor,
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
class _EditAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isProvider;
  final bool canSave;
  final bool isLoading;
  final VoidCallback onSave;

  const _EditAppBar({
    required this.isProvider,
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
      title: Text(
        isProvider ? 'Edit Provider Profile' : 'Edit Profile',
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1A1A2E),
        ),
      ),
      // Quick-save action in app bar
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: canSave ? onSave : null,
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.primary,
                        ),
                      ),
                    )
                  : Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: canSave ? AppTheme.primary : AppTheme.textGrey,
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

// ── Specialty picker ──────────────────────────────────────────────────────────
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
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _specialties.map((s) {
        final isSelected = s == selected;
        return GestureDetector(
          onTap: () => onChanged(s),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
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
                  'Save Changes',
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
