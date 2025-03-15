import 'action_result.dart';

class ActionResultFailure<T> extends ActionResult<T> {
  ActionResultFailure({
    required String errorMessage,
    required int statusCode,
  }) : super(errorMessage: errorMessage, statusCode: statusCode);
}