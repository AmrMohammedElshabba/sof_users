class SOFUser {
  final int userId;
  final String displayName;
  final String profileImage;
  final int reputation;

  SOFUser({
    required this.userId,
    required this.displayName,
    required this.profileImage,
    required this.reputation,
  });

  factory SOFUser.fromJson(Map<String, dynamic> json) {
    return SOFUser(
      userId: json['user_id'] ?? 0,
      displayName: json['display_name'] ?? '',
      profileImage: json['profile_image'] ?? '',
      reputation: (json['reputation'] ?? 0) as int,
    );
  }
}