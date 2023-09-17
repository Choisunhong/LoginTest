class MemberDTO {
  final int id;
  final String userName;
  final String userPw;

  MemberDTO({
    required this.id,
    required this.userName,
    required this.userPw,
  });

  factory MemberDTO.fromJson(Map<String, dynamic> json) {
    return MemberDTO(
      id: json['id'],
      userName: json['userName'],
      userPw: json['userPw'],
    );
  }
}