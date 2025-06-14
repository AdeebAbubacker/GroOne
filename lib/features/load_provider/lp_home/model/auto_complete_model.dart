class AutoCompleteModel {
  AutoCompleteModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final Data? data;

  AutoCompleteModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) {
    return AutoCompleteModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory AutoCompleteModel.fromJson(Map<String, dynamic> json){
    return AutoCompleteModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.predictions,
    required this.status,
  });

  final List<Prediction> predictions;
  final String status;

  Data copyWith({
    List<Prediction>? predictions,
    String? status,
  }) {
    return Data(
      predictions: predictions ?? this.predictions,
      status: status ?? this.status,
    );
  }

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      predictions: json["predictions"] == null ? [] : List<Prediction>.from(json["predictions"]!.map((x) => Prediction.fromJson(x))),
      status: json["status"] ?? "",
    );
  }

}

class Prediction {
  Prediction({
    required this.description,
    required this.matchedSubstrings,
    required this.placeId,
    required this.reference,
    required this.structuredFormatting,
    required this.terms,
    required this.types,
  });

  final String description;
  final List<MatchedSubstring> matchedSubstrings;
  final String placeId;
  final String reference;
  final StructuredFormatting? structuredFormatting;
  final List<Term> terms;
  final List<String> types;

  Prediction copyWith({
    String? description,
    List<MatchedSubstring>? matchedSubstrings,
    String? placeId,
    String? reference,
    StructuredFormatting? structuredFormatting,
    List<Term>? terms,
    List<String>? types,
  }) {
    return Prediction(
      description: description ?? this.description,
      matchedSubstrings: matchedSubstrings ?? this.matchedSubstrings,
      placeId: placeId ?? this.placeId,
      reference: reference ?? this.reference,
      structuredFormatting: structuredFormatting ?? this.structuredFormatting,
      terms: terms ?? this.terms,
      types: types ?? this.types,
    );
  }

  factory Prediction.fromJson(Map<String, dynamic> json){
    return Prediction(
      description: json["description"] ?? "",
      matchedSubstrings: json["matched_substrings"] == null ? [] : List<MatchedSubstring>.from(json["matched_substrings"]!.map((x) => MatchedSubstring.fromJson(x))),
      placeId: json["place_id"] ?? "",
      reference: json["reference"] ?? "",
      structuredFormatting: json["structured_formatting"] == null ? null : StructuredFormatting.fromJson(json["structured_formatting"]),
      terms: json["terms"] == null ? [] : List<Term>.from(json["terms"]!.map((x) => Term.fromJson(x))),
      types: json["types"] == null ? [] : List<String>.from(json["types"]!.map((x) => x)),
    );
  }

}

class MatchedSubstring {
  MatchedSubstring({
    required this.length,
    required this.offset,
  });

  final num length;
  final num offset;

  MatchedSubstring copyWith({
    num? length,
    num? offset,
  }) {
    return MatchedSubstring(
      length: length ?? this.length,
      offset: offset ?? this.offset,
    );
  }

  factory MatchedSubstring.fromJson(Map<String, dynamic> json){
    return MatchedSubstring(
      length: json["length"] ?? 0,
      offset: json["offset"] ?? 0,
    );
  }

}

class StructuredFormatting {
  StructuredFormatting({
    required this.mainText,
    required this.mainTextMatchedSubstrings,
    required this.secondaryText,
  });

  final String mainText;
  final List<MatchedSubstring> mainTextMatchedSubstrings;
  final String secondaryText;

  StructuredFormatting copyWith({
    String? mainText,
    List<MatchedSubstring>? mainTextMatchedSubstrings,
    String? secondaryText,
  }) {
    return StructuredFormatting(
      mainText: mainText ?? this.mainText,
      mainTextMatchedSubstrings: mainTextMatchedSubstrings ?? this.mainTextMatchedSubstrings,
      secondaryText: secondaryText ?? this.secondaryText,
    );
  }

  factory StructuredFormatting.fromJson(Map<String, dynamic> json){
    return StructuredFormatting(
      mainText: json["main_text"] ?? "",
      mainTextMatchedSubstrings: json["main_text_matched_substrings"] == null ? [] : List<MatchedSubstring>.from(json["main_text_matched_substrings"]!.map((x) => MatchedSubstring.fromJson(x))),
      secondaryText: json["secondary_text"] ?? "",
    );
  }

}

class Term {
  Term({
    required this.offset,
    required this.value,
  });

  final num offset;
  final String value;

  Term copyWith({
    num? offset,
    String? value,
  }) {
    return Term(
      offset: offset ?? this.offset,
      value: value ?? this.value,
    );
  }

  factory Term.fromJson(Map<String, dynamic> json){
    return Term(
      offset: json["offset"] ?? 0,
      value: json["value"] ?? "",
    );
  }

}
