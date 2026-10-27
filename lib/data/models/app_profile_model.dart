import 'register_model.dart';

class AppProfileModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final UserRole role;
  final String specialty;

  const AppProfileModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    required this.role,
    required this.specialty,
  });

  factory AppProfileModel.fromMap(Map<String, dynamic> map) {
    final rawRole = map['role'] as String?;
    return AppProfileModel(
      id: map['id'] as String? ?? '',
      fullName: map['full_name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      address: map['address'] as String? ?? '',
      role: switch (rawRole) {
        'provider' => UserRole.provider,
        'admin' => UserRole.admin,
        _ => UserRole.client,
      },
      specialty: map['specialty'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'full_name': fullName,
    'email': email,
    'phone': phone,
    'address': address,
    'role': role.name,
    'specialty': specialty,
    'updated_at': DateTime.now().toIso8601String(),
  };
}
