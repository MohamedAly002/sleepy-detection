
import 'package:intl/intl.dart';

class MyDateUtils{
  static formateTaskDate(DateTime  dateTime){
    DateFormat formatter=DateFormat( 'dd/MM/yyyy');
    return formatter.format(dateTime);

  }
  static DateTime ExtractDateOnly(DateTime dateTime){
    return DateTime(dateTime.year,dateTime.month,dateTime.day);
  }
}