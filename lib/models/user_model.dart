enum UserRole {
  customer,
  worker,
  admin,
}

class UserModel {
  final String id;
  final String phoneNumber;
  final String fullName;
  final String? dateOfBirth;
  final String? gender;
  final String address;
  final String pincode;
  final String district;
  final String language; // 'en', 'ml', 'hi', 'ta'
  final UserRole role;
  final int helpPoints;
  final bool isElderlyModeEnabled;
  final String? profileImageUrl;

  const UserModel({
    required this.id,
    required this.phoneNumber,
    required this.fullName,
    this.dateOfBirth,
    this.gender,
    required this.address,
    required this.pincode,
    required this.district,
    this.language = 'en',
    this.role = UserRole.customer,
    this.helpPoints = 240,
    this.isElderlyModeEnabled = false,
    this.profileImageUrl,
  });

  UserModel copyWith({
    String? id,
    String? phoneNumber,
    String? fullName,
    String? dateOfBirth,
    String? gender,
    String? address,
    String? pincode,
    String? district,
    String? language,
    UserRole? role,
    int? helpPoints,
    bool? isElderlyModeEnabled,
    String? profileImageUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      pincode: pincode ?? this.pincode,
      district: district ?? this.district,
      language: language ?? this.language,
      role: role ?? this.role,
      helpPoints: helpPoints ?? this.helpPoints,
      isElderlyModeEnabled: isElderlyModeEnabled ?? this.isElderlyModeEnabled,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'fullName': fullName,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'address': address,
      'pincode': pincode,
      'district': district,
      'language': language,
      'role': role.name,
      'helpPoints': helpPoints,
      'isElderlyModeEnabled': isElderlyModeEnabled,
      'profileImageUrl': profileImageUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      fullName: map['fullName'] ?? '',
      dateOfBirth: map['dateOfBirth'],
      gender: map['gender'],
      address: map['address'] ?? '',
      pincode: map['pincode'] ?? '',
      district: map['district'] ?? '',
      language: map['language'] ?? 'en',
      role: UserRole.values.firstWhere(
        (r) => r.name == map['role'],
        orElse: () => UserRole.customer,
      ),
      helpPoints: map['helpPoints']?.toInt() ?? 0,
      isElderlyModeEnabled: map['isElderlyModeEnabled'] ?? false,
      profileImageUrl: map['profileImageUrl'],
    );
  }
}
