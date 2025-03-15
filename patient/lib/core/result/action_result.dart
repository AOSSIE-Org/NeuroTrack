class ActionResult<T> {

  final T? data;
  final String? errorMessage;
  final int? statusCode;

  ActionResult({this.data, this.errorMessage, this.statusCode});

}