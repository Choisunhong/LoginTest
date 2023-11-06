class StatisticResponseDTO {
  int memberId;
  int nClean;
  int nHate;
  int sta_clean;
  int sta_hate;
  StatisticResponseDTO(
      {required this.memberId,
      required this.nClean,
      required this.nHate,
      required this.sta_clean,
      required this.sta_hate});
  factory StatisticResponseDTO.fromJson(Map<String, dynamic> json) {
    return StatisticResponseDTO(
      memberId: json['memberId'],
      nClean: json['nClean'],
      nHate: json['nHate'],
      sta_clean: json['sta_clean'],
      sta_hate: json['sta_hate'],
    );
  }
}
