class TrackingConsentStatusResponse {
  TrackingConsentStatusResponse({
    required this.response,
    required this.message,
  });

  final Response? response;
  final String message;

  TrackingConsentStatusResponse copyWith({
    Response? response,
    String? message,
  }) {
    return TrackingConsentStatusResponse(
      response: response ?? this.response,
      message: message ?? this.message,
    );
  }

  factory TrackingConsentStatusResponse.fromJson(Map<String, dynamic> json){
    return TrackingConsentStatusResponse(
      response: json["response"] == null ? null : Response.fromJson(json["response"]),
      message: json["message"] ?? "",
    );
  }

}

class Response {
  Response({
    required this.number,
    required this.currentConsent,
    required this.consent,
    required this.responseOperator,
    required this.message,
    required this.consentSuggestion,
  });

  final String number;
  final String currentConsent;
  final String consent;
  final String responseOperator;
  final String message;
  final dynamic consentSuggestion;

  Response copyWith({
    String? number,
    String? currentConsent,
    String? consent,
    String? responseOperator,
    String? message,
    dynamic? consentSuggestion,
  }) {
    return Response(
      number: number ?? this.number,
      currentConsent: currentConsent ?? this.currentConsent,
      consent: consent ?? this.consent,
      responseOperator: responseOperator ?? this.responseOperator,
      message: message ?? this.message,
      consentSuggestion: consentSuggestion ?? this.consentSuggestion,
    );
  }

  factory Response.fromJson(Map<String, dynamic> json){
    return Response(
      number: json["number"] ?? "",
      currentConsent: json["current_consent"] ?? "",
      consent: json["consent"] ?? "",
      responseOperator: json["operator"] ?? "",
      message: json["message"] ?? "",
      consentSuggestion: json["consent_suggestion"],
    );
  }

}
