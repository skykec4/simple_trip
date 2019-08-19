import 'package:intl/intl.dart';

var formatter = new NumberFormat("#,###");

class IntegerFormat {
  String getFormat(int format) => formatter.format(format);
}
