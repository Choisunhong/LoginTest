class Member {
  final int id;
  final String userName;
  final String userPw;

  Member({
    required this.id,
    required this.userName,
    required this.userPw,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      userName: json['userName'],
      userPw: json['userPw'],
    );
  }
}