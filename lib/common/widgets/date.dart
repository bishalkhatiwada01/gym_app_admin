import 'package:intl/intl.dart';

String formatDateTime(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  return DateFormat.yMMMEd().add_jm().format(dateTime);
}

String formatDistanceToNowStrict(String dateString) {
  DateTime now = DateTime.now();
  DateTime date = DateTime.parse(dateString);
  Duration difference = now.difference(date);
  if (difference.inSeconds < 60) {
    int seconds = difference.inSeconds;
    if (difference.inSeconds.isNegative) {
      return '0 seconds';
    } else {
      return '$seconds seconds';
    }
  } else if (difference.inMinutes < 60) {
    int minutes = difference.inMinutes;
    return '$minutes minutes';
  } else if (difference.inHours < 24) {
    int hours = difference.inHours;
    return '$hours hours';
  } else if (difference.inDays < 30) {
    int days = difference.inDays;
    return '$days days';
  } else if (difference.inDays < 365) {
    int months = difference.inDays ~/ 30;
    return '$months months';
  } else {
    int years = difference.inDays ~/ 365;
    return '$years years';
  }
}

String timeAgo(DateTime date) {
  Duration diff = DateTime.now().difference(date);
  if (diff.inDays > 0) {
    return '${diff.inDays} day(s) ago';
  } else if (diff.inHours > 0) {
    return '${diff.inHours} hour(s) ago';
  } else if (diff.inMinutes > 0) {
    return '${diff.inMinutes} min(s) ago';
  } else {
    return 'Just now';
  }
}
