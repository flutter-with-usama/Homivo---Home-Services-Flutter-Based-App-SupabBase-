/// Holds the registration form state as a pure data class.
enum UserRole { client, provider, admin }

class RegisterModel {
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String password;
  final UserRole role;
  final String specialty; // provider-only: e.g. "Plumbing"
  final bool isAddressObscured;
  final bool isPasswordObscured;
  final bool isLoading;
  final String? errorMessage;

  const RegisterModel({
    this.fullName = '',
    this.email = '',
    this.phone = '',
    this.address = '',
    this.password = '',
    this.role = UserRole.client,
    this.specialty = '',
    this.isAddressObscured = false,
    this.isPasswordObscured = true,
    this.isLoading = false,
    this.errorMessage,
  });

  RegisterModel copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? address,
    String? password,
    UserRole? role,
    String? specialty,
    bool? isAddressObscured,
    bool? isPasswordObscured,
    bool? isLoading,
    String? errorMessage,
  }) => RegisterModel(
    fullName: fullName ?? this.fullName,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    address: address ?? this.address,
    password: password ?? this.password,
    role: role ?? this.role,
    specialty: specialty ?? this.specialty,
    isAddressObscured: isAddressObscured ?? this.isAddressObscured,
    isPasswordObscured: isPasswordObscured ?? this.isPasswordObscured,
    isLoading: isLoading ?? this.isLoading,
    errorMessage: errorMessage,
  );

  bool get canSubmit =>
      fullName.trim().isNotEmpty &&
      email.trim().isNotEmpty &&
      phone.trim().isNotEmpty &&
      address.trim().isNotEmpty &&
      password.isNotEmpty &&
      (role == UserRole.client || specialty.trim().isNotEmpty);
}
