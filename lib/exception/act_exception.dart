import 'package:chat_hub/enums/act_error_enum.dart';

class ActException implements Exception {

  final String code;

  final String message;

  ActException(this.code, this.message);

  static ActException byError(ActErrorEnum errorEnum) {
    return ActException(errorEnum.code, errorEnum.message);
  }

  String toString() {
    return "Code: ${this.code}, Exception: ${this.message}";
  }
}