/// Client profile data — pure data class, no Flutter dependencies.
class ClientProfileModel {
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String initials;
  final int totalBookings;
  final int completedBookings;

  const ClientProfileModel({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    required this.initials,
    required this.totalBookings,
    required this.completedBookings,
  });

  ClientProfileModel copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? address,
    String? initials,
    int? totalBookings,
    int? completedBookings,
  }) =>
      ClientProfileModel(
        fullName:          fullName          ?? this.fullName,
        email:             email             ?? this.email,
        phone:             phone             ?? this.phone,
        address:           address           ?? this.address,
        initials:          initials          ?? this.initials,
        totalBookings:     totalBookings     ?? this.totalBookings,
        completedBookings: completedBookings ?? this.completedBookings,
      );
}
