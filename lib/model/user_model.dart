class AppUser {
  final String uid;
  final String name;
  final String email;
  final int streak;
  final String photoUrl;

  

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.streak,
    required this.photoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "streak": streak,
      "photoUrl": photoUrl,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map["uid"],
      name: map["name"],
      email: map["email"],
      streak: map["streak"],
      photoUrl: map["photoUrl"],
    );
  }
}
