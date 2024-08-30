class UserModel {
  final String id;
  final String email;
  final String role;
  final String displayName;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    required this.displayName,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? '',
      displayName: data['displayName'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'displayName': displayName,
    };
  }
}
