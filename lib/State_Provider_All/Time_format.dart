import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TimeFormat {

  //method to format the time returned form the django server 
  static String formatDate(String isoDate) {
    try {
      DateTime parsedDate = DateTime.parse(isoDate);
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      DateTime yesterday = today.subtract(const Duration(days: 1));

      if (parsedDate.isAfter(today)) {
        // If the date is today, show "Today HH:mm"
        return "Today ${DateFormat('HH:mm').format(parsedDate)}";
      } else if (parsedDate.isAfter(yesterday)) {
        // If the date is yesterday, show "Yesterday HH:mm"
        return "Yesterday ${DateFormat('HH:mm').format(parsedDate)}";
      } else {
        // Otherwise, show full date "dd/MM/yyyy HH:mm"
        return DateFormat('dd/MM/yyyy HH:mm').format(parsedDate);
      }
    } catch (e) {
      print('Error formatting date: $e');
      return isoDate; // Return original if there's an error
    }
  }

  // Helper function to format timestamps
  //this method is for formatting the firebase time object 
  static String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return "Time Unavailable";
    
    DateTime dateTime = timestamp.toDate(); // Convert to DateTime
    return DateFormat('hh:mm a').format(dateTime); // Format to "12:30 PM"
  }
  
  //
}
