import 'package:fluttertoast/fluttertoast.dart';

showSnackbar({required String message}) {
  return Fluttertoast.showToast(
    msg: message,
    gravity: ToastGravity.BOTTOM,
  );
}
