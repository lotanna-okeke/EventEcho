import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test/data/functions.dart';
import 'package:test/screens/event_detail_screen.dart';
import 'package:test/models/event.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final bool showDate;
  final Function() onEdit;
  final Function() onDelete;

  const EventCard({
    super.key,
    required this.event,
    required this.showDate,
    required this.onEdit,
    required this.onDelete,
  });

  String _getFormattedDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('d MMM yyyy')
        .format(date); // Formats date to 'd MMM yyyy'
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = _getFormattedDate(event.expiryDate);
    final dateParts = formattedDate.split(' ');

    // Responsive Sizing
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double fontSizeLarge = screenWidth * 0.05;
    double fontSizeMedium = screenWidth * 0.035;
    double fontSizeSmall = screenWidth * 0.03;
    double paddingHorizontal = screenWidth * 0.05;
    double paddingVertical = screenHeight * 0.008;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: paddingHorizontal, vertical: paddingVertical),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailScreen(
                event: event,
                onEdit: onEdit,
                onDelete: onDelete,
              ),
            ),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showDate) ...[
              Column(
                children: [
                  Text(
                    dateParts[0], // Day
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: fontSizeLarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    dateParts[1], // Abbreviated month
                    style:
                        TextStyle(color: Colors.grey, fontSize: fontSizeMedium),
                  ),
                  Text(
                    dateParts[2], // Year
                    style:
                        TextStyle(color: Colors.grey, fontSize: fontSizeMedium),
                  ),
                ],
              ),
              SizedBox(width: screenWidth * 0.025),
            ] else ...[
              SizedBox(width: screenWidth * 0.11),
            ],
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.025),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            determineEmoji(
                                event.expiryDate.toString(), event.category),
                            style: TextStyle(fontSize: fontSizeLarge),
                          ),
                          SizedBox(width: screenWidth * 0.04),
                          Flexible(
                            child: Text(
                              event.title,
                              style: TextStyle(
                                fontSize: fontSizeLarge,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.001),
                      Container(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.2),
                        height: screenHeight * 0.0015,
                      ),
                      SizedBox(height: screenHeight * 0.006),
                      Text(
                        event.content,
                        style: TextStyle(fontSize: fontSizeSmall),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
