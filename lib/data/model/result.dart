import 'package:flutter/widgets.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/global_variables.dart';

abstract class Result<T> {
  const Result();
}

// Success case class extends Result with a value of type T
class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}

// Error case class extends Result with a specific ErrorType
class Error<T> extends Result<T> {
  final ErrorType type;
  const Error(this.type);
}


// Abstract class ErrorType to serve as a base for all error types
abstract class ErrorType {
  String getText(BuildContext context);
}

// Concrete ErrorType classes for specific error scenarios
class ErrorWithMessage extends ErrorType {
  final String? code;
  final String message;
  ErrorWithMessage({this.code, required this.message});

  @override
  String getText(BuildContext context) {
    if(code != null){
      return "Message: $message, Code: $code";
    }else{
      return "Message: $message";
    }
  }

  factory ErrorWithMessage.fromApiResponse(Map<String, dynamic> response) {
    return ErrorWithMessage(
      message: response['message'] ?? "",
    );
  }

}

class TokenExpiredError extends ErrorType {
  @override
  String getText(BuildContext context) {
    return context.appText.tokenExpireError.capitalize;
  }
}

class InvalidTokenError extends ErrorType {
  final String? message;

  InvalidTokenError({this.message});

  @override
  String getText(BuildContext context) {
    return message ?? '';
  }
}

class BadRequestError extends ErrorType {
  final String? message;
  BadRequestError({this.message});

  @override
  String getText(BuildContext context) {
    if(message != null){
      return message!;
    } else {
      return context.appText.badRequestError.capitalize;
    }
  }

  factory BadRequestError.fromApiResponse(Map<String, dynamic> response) {
    return BadRequestError(
      message: response['message'] ?? "",
    );
  }

}



class InternalServerError extends ErrorType {
  final String? message;
  InternalServerError({this.message});
  
  @override
  String getText(BuildContext context) {
    return message ?? '';
  }

  factory InternalServerError.fromApiResponse(Map<String, dynamic> response) {
    return InternalServerError(
      message: response['message'] ?? "",
    );
  }
}

class ConflictError extends ErrorType {
  final String? message;

  ConflictError({this.message});

  @override
  String getText(BuildContext context) {
    return message ?? '';
  }
}

// Not Found Error
class NotFoundError extends ErrorType {
  final String? message;
  NotFoundError({this.message});
  @override
  String getText(BuildContext context) {
    if(message != null){
      return message!;
    }
    return context.appText.notFound.capitalize ?? '';
  }

  factory NotFoundError.fromApiResponse(Map<String, dynamic> response) {
    return NotFoundError(
      message: response['message'] ?? "",
    );
  }

}

class UnauthenticatedError extends ErrorType {
  final String? message;
  UnauthenticatedError({this.message});
  @override
  String getText(BuildContext context) {
    if(message != null){
      return message!;
    }
    return context.appText.unauthenticatedError.capitalize;
  }

  factory UnauthenticatedError.fromApiResponse(Map<String, dynamic> response) {
    return UnauthenticatedError(
      message: response['message'] ?? "",
    );
  }
}

class NetworkTimeoutError extends ErrorType {
  @override
  String getText(BuildContext context) {
    return context.appText.timeOutError.capitalize;
  }
}

class RequestCancelledError extends ErrorType {
  @override
  String getText(BuildContext context) {
    return context.appText.requestCancelledError.capitalize;
  }
}

class DeserializationError extends ErrorType {
  @override
  String getText(BuildContext context) {
    return context.appText.deserializationError.capitalize;
  }
}

class ResponseStatusFailed extends ErrorType {
  final String? message;

  ResponseStatusFailed({this.message});

  @override
  String getText([BuildContext? context]) {
    if (message != null && message!.isNotEmpty) return message!;
    final ctx = context ?? appContext; // fallback
    return ctx.appText.responseStatusFail; // or ctx.appText.conflictError
  }
}


class SerializationError extends ErrorType {
  @override
  String getText(BuildContext context) {
    return context.appText.serializationError.capitalize;
  }
}

class GenericError extends ErrorType {
  @override
  String getText(BuildContext context) {
    return context.appText.genericError;
  }
}

class LoginAttemptError extends ErrorType {
  @override
  String getText(BuildContext context) {
    return context.appText.loginAttemptError.capitalize;
  }
}

class InternetNetworkError extends ErrorType {
  @override
  String getText(BuildContext context) {
    return context.appText.networkError.capitalize;
  }
}

class InvalidInputError extends ErrorType {
  @override
  String getText(BuildContext context) {
    return context.appText.invalidInput.capitalize;
  }
}
