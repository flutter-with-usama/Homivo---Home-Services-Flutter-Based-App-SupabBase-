/// Holds the login form state as a pure data class.
class LoginModel {
  final String email;
  final String password;
  final bool isPasswordObscured;
  final bool isLoading;
  final String? errorMessage;

  const LoginModel({
    this.email = '',
    this.password = '',
    this.isPasswordObscured = true,
    this.isLoading = false,
    this.errorMessage,
  });

  LoginModel copyWith({
    String? email,
    String? password,
    bool? isPasswordObscured,
    bool? isLoading,
    String? errorMessage,
  }) =>
      LoginModel(
        email: email ?? this.email,
        password: password ?? this.password,
        isPasswordObscured: isPasswordObscured ?? this.isPasswordObscured,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage,
      );
}
