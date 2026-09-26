enum WorkerVerificationStatus {
  pending,
  underReview,
  verified,
  rejected,
}

class WorkerModel {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String? profileImageUrl;
  final double rating;
  final int totalReviews;
  final int completedJobs;
  final String primarySkill;
  final List<String> skills;
  final double distanceKm;
  final int etaMinutes;
  final WorkerVerificationStatus verificationStatus;
  final bool isOnline;
  final double todayEarnings;
  final double weeklyEarnings;
  final double withdrawableBalance;
  final String vehicleType;
  final String address;

  const WorkerModel({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    this.profileImageUrl,
    this.rating = 4.9,
    this.totalReviews = 120,
    this.completedJobs = 142,
    required this.primarySkill,
    this.skills = const ['Groceries', 'Medicines', 'Errands'],
    this.distanceKm = 1.2,
    this.etaMinutes = 10,
    this.verificationStatus = WorkerVerificationStatus.verified,
    this.isOnline = true,
    this.todayEarnings = 850.0,
    this.weeklyEarnings = 4920.0,
    this.withdrawableBalance = 3200.0,
    this.vehicleType = 'Two Wheeler (Motorcycle)',
    this.address = 'Kaloor, Kochi, Kerala',
  });

  WorkerModel copyWith({
    String? id,
    String? fullName,
    String? phoneNumber,
    String? profileImageUrl,
    double? rating,
    int? totalReviews,
    int? completedJobs,
    String? primarySkill,
    List<String>? skills,
    double? distanceKm,
    int? etaMinutes,
    WorkerVerificationStatus? verificationStatus,
    bool? isOnline,
    double? todayEarnings,
    double? weeklyEarnings,
    double? withdrawableBalance,
    String? vehicleType,
    String? address,
  }) {
    return WorkerModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      completedJobs: completedJobs ?? this.completedJobs,
      primarySkill: primarySkill ?? this.primarySkill,
      skills: skills ?? this.skills,
      distanceKm: distanceKm ?? this.distanceKm,
      etaMinutes: etaMinutes ?? this.etaMinutes,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      isOnline: isOnline ?? this.isOnline,
      todayEarnings: todayEarnings ?? this.todayEarnings,
      weeklyEarnings: weeklyEarnings ?? this.weeklyEarnings,
      withdrawableBalance: withdrawableBalance ?? this.withdrawableBalance,
      vehicleType: vehicleType ?? this.vehicleType,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'rating': rating,
      'totalReviews': totalReviews,
      'completedJobs': completedJobs,
      'primarySkill': primarySkill,
      'skills': skills,
      'distanceKm': distanceKm,
      'etaMinutes': etaMinutes,
      'verificationStatus': verificationStatus.name,
      'isOnline': isOnline,
      'todayEarnings': todayEarnings,
      'weeklyEarnings': weeklyEarnings,
      'withdrawableBalance': withdrawableBalance,
      'vehicleType': vehicleType,
      'address': address,
    };
  }

  factory WorkerModel.fromMap(Map<String, dynamic> map) {
    return WorkerModel(
      id: map['id'] ?? '',
      fullName: map['fullName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      profileImageUrl: map['profileImageUrl'],
      rating: (map['rating'] ?? 4.9).toDouble(),
      totalReviews: map['totalReviews']?.toInt() ?? 0,
      completedJobs: map['completedJobs']?.toInt() ?? 0,
      primarySkill: map['primarySkill'] ?? 'General Helper',
      skills: List<String>.from(map['skills'] ?? []),
      distanceKm: (map['distanceKm'] ?? 1.0).toDouble(),
      etaMinutes: map['etaMinutes']?.toInt() ?? 10,
      verificationStatus: WorkerVerificationStatus.values.firstWhere(
        (v) => v.name == map['verificationStatus'],
        orElse: () => WorkerVerificationStatus.verified,
      ),
      isOnline: map['isOnline'] ?? true,
      todayEarnings: (map['todayEarnings'] ?? 0.0).toDouble(),
      weeklyEarnings: (map['weeklyEarnings'] ?? 0.0).toDouble(),
      withdrawableBalance: (map['withdrawableBalance'] ?? 0.0).toDouble(),
      vehicleType: map['vehicleType'] ?? '',
      address: map['address'] ?? '',
    );
  }
}
