class ESP{
  final double temp;
  final double avg;
  final double bpm;

  ESP({this.temp, this.avg,this.bpm});
  factory ESP.fromJson(Map<dynamic,dynamic> json){
    double dataValue(dynamic source){
      try{
        return double.parse(source.toString());
      } on FormatException{
        return -1;
      }
    }
    return ESP(
      temp: dataValue(json['Temperature']),
      bpm: dataValue(json['BPM']),
      avg: dataValue(json['Avg']));
  }
}