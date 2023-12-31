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
    var memberId = json['memberId'] ?? 0;
    var nClean = json['nClean'] ?? 0;
    var nHate = json['nHate'] ?? 0;
    var sta_clean = json['sta_clean'] ?? 0;
    var sta_hate = json['sta_hate'] ?? 0;

    print(
        'memberId: $memberId, nClean: $nClean, nHate: $nHate, sta_clean: $sta_clean, sta_hate: $sta_hate');
    return StatisticResponseDTO(
      memberId: json['memberId'] ?? 0,
      sta_clean: json['sta_clean'] ?? 0,
      sta_hate: json['sta_hate'] ?? 0,
      nClean: json['nClean']?? json['nclean'] ?? 0,
      nHate: json['nHate']?? json['nhate']  ?? 0,
    );
  }
}
