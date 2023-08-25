class AgentModel {
  int agentId;
  String agentName;
  String depotName;
  String depotId;
  bool isChecked;

  AgentModel(
      {this.agentId, this.agentName, this.depotName, this.depotId, isChecked});

  factory AgentModel.fromJson(Map<String, dynamic> json) {
    return AgentModel(
        agentId: json['agentId'],
        agentName: json['agentName'],
        depotName: json['depotName'],
        depotId: json['depotId'],
        isChecked: json['isChecked']);
  }

  Map<String, dynamic> toJson() => {
        'agentId': agentId,
        'agentName': agentName,
        'depotName': depotName,
        'depotId': depotId,
        'isChecked': isChecked
      };
}
