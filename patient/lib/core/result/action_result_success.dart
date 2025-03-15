import 'action_result.dart';

class ActionResultSuccess<T> extends ActionResult<T> {

  ActionResultSuccess({
    required T data,
    required int statusCode,
  }) : super(data: data, statusCode: statusCode);

}