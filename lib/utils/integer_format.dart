import 'package:intl/intl.dart';

var formatter = new NumberFormat("#,###");
var formatter2 = new NumberFormat("#,###.##");

class IntegerFormat {
  static String getFormat(int format) => formatter.format(format);
  static String getFormat2(double format) => formatter2.format(format);
}
