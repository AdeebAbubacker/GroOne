class LanguageModel {
  final int id;
  final String name;
  final String languageText;

  LanguageModel({
    required this.id,
    required this.name,
    required this.languageText,
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      id: json['id'],
      name: json['name'],
      languageText: json['languageText'],
    );
  }
}
