class ModelsModel {
  final String id;
  final int created;
  final String root;

  ModelsModel({required this.created, required this.id, required this.root});

  factory ModelsModel.fromJson(Map<String, dynamic> json) => ModelsModel(
        id: json["id"],
        created: json["created"],
        root: json["rooted"],
      );
  static List<ModelsModel> modelsFromSnapshot(List modelSnapshot) {
    return modelSnapshot.map((data) => ModelsModel.fromJson(data)).toList();
  }

}
