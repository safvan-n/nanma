class FamilyMemberModel {
  final String id;
  final String name;
  final String relationship; // 'Mother', 'Father', 'Grandmother', etc.
  final String phoneNumber;
  final String address;
  final bool isElderly;
  final int activeRequestsCount;

  const FamilyMemberModel({
    required this.id,
    required this.name,
    required this.relationship,
    required this.phoneNumber,
    required this.address,
    this.isElderly = true,
    this.activeRequestsCount = 1,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'relationship': relationship,
    'phoneNumber': phoneNumber,
    'address': address,
    'isElderly': isElderly,
    'activeRequestsCount': activeRequestsCount,
  };
}
