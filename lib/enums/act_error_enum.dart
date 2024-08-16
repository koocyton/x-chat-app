enum ActErrorEnum {

  API_REQUEST_TIMEOUT(code: "60101", message: "network request timeout");
  
  final String code;

  final String message;

  const ActErrorEnum({
    required this.code,
    required this.message
  });
  
  
}