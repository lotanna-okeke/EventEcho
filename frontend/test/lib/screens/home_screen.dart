import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:test/data/data.dart';
import 'package:test/models/event.dart';
import 'package:test/screens/add_event.dart';
import 'package:test/widgets/app_drawer.dart';
import 'package:test/widgets/event_card.dart';
import 'package:test/widgets/event_seach.dart';
import 'package:test/widgets/noEntry.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:http/http.dart' as http;

import 'calendar_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

String uid = "";

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Event>> diaryEntriesFuture;
  final int _itemsPerPage = 10; // Number of items per page
  int _currentPage = 0; // Current page index
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String? username;

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
    fetchUserName(uid);

    tz.initializeTimeZones();
    _initializeNotifications();
    diaryEntriesFuture = fetchEvents(uid);
  }

  void _initializeNotifications() async {
    // Android settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS settings
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        // Handle the received notification here (optional)
      },
    );

    // Combine both settings
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // Initialize the plugin
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> fetchUserName(String uid) async {
    final url = Uri.parse('http://10.0.2.2:8080/api/users/$uid');

    try {
      final response = await http.get(url);

      print(response.statusCode);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          username = data['name'];
        });
        print(username);
      } else {
        throw Exception('Failed to load username');
      }
    } catch (e) {
      print('Error: $e');
      return;
    }
  }

  void _addEvent() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddEventPage(
                uid: uid,
              )),
    );
    // showNotification();
    setState(() {
      diaryEntriesFuture = fetchEvents(uid);
    });
  }

  void _onEditEvent() {
    setState(() {
      diaryEntriesFuture = fetchEvents(uid);
    });
  }

  void _onDeleteEvent() {
    setState(() {
      diaryEntriesFuture = fetchEvents(uid);
    });
  }

  List<Event> _getPaginatedEntries(List<Event> diaryEntries) {
    int start = _currentPage * _itemsPerPage;
    int end = start + _itemsPerPage;
    return diaryEntries.sublist(
      start,
      end > diaryEntries.length ? diaryEntries.length : end,
    );
  }

  void _nextPage(List<Event> diaryEntries) {
    setState(() {
      if ((_currentPage + 1) * _itemsPerPage < diaryEntries.length) {
        _currentPage++;
      }
    });
  }

  void _prevPage() {
    setState(() {
      if (_currentPage > 0) {
        _currentPage--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double fontSizeTitle = screenWidth * 0.05;
    double paddingValue = screenWidth * 0.04;
    String currentDay = DateFormat('d').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Event Echo',
          style: TextStyle(
            color: Colors.black,
            fontSize: fontSizeTitle,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          FutureBuilder<List<Event>>(
            future: diaryEntriesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              } else if (snapshot.hasError) {
                return IconButton(
                  icon: const Icon(Icons.error, color: Colors.red),
                  onPressed: () {},
                );
              } else if (snapshot.hasData) {
                return IconButton(
                  icon: const Icon(Icons.search, color: Colors.black),
                  onPressed: () {
                    showSearch(
                        context: context,
                        delegate: EventSearchDelegate(
                            snapshot.data!, _onEditEvent, _onDeleteEvent));
                    diaryEntriesFuture = fetchEvents(uid);
                  },
                );
              } else {
                return Container();
              }
            },
          ),
          FutureBuilder<List<Event>>(
            future: diaryEntriesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              } else if (snapshot.hasError) {
                return IconButton(
                  icon: const Icon(Icons.error, color: Colors.red),
                  onPressed: () {},
                );
              } else if (snapshot.hasData) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: paddingValue),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CalendarScreen(
                                diaryEntries: snapshot.data!,
                                onEdit: _onEditEvent,
                                onDelete: _onDeleteEvent,
                                onAdd: _addEvent,
                              ),
                            ),
                          );
                          diaryEntriesFuture = fetchEvents(uid);
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(Icons.calendar_today,
                                color: Colors.black),
                            Positioned(
                              top: screenHeight * 0.01,
                              child: Text(
                                currentDay,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: fontSizeTitle * 0.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
      drawer: AppDrawer(username: username),
      body: FutureBuilder<List<Event>>(
        future: diaryEntriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<Event> diaryEntries = snapshot.data!;
            if (diaryEntries.isEmpty) {
              return const NoEntry(
                  icons: Icons.alarm_off_rounded, text: 'No Event');
            }

            // Sort entries by expiryDate in ascending order
            diaryEntries.sort((a, b) {
              try {
                if (a.expiryDate == null || b.expiryDate == null) {
                  return 0;
                }
                DateTime dateA = a.expiryDate!;
                DateTime dateB = b.expiryDate!;
                return dateA.compareTo(dateB);
              } catch (e) {
                print('Error parsing expiryDate: $e');
                return 0;
              }
            });

            List<Event> paginatedEntries = _getPaginatedEntries(diaryEntries);

            // Schedule notifications for each event
            for (var event in diaryEntries) {
              _scheduleNotification(event);
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: paginatedEntries.length,
                    itemBuilder: (context, index) {
                      bool showDate = index == 0 ||
                          paginatedEntries[index].expiryDate !=
                              paginatedEntries[index - 1].expiryDate;
                      return EventCard(
                        event: paginatedEntries[index],
                        showDate: showDate,
                        onEdit: _onEditEvent,
                        onDelete: _onDeleteEvent,
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_currentPage > 0)
                      ElevatedButton(
                        onPressed: _prevPage,
                        child: Text(
                          '<',
                          style: TextStyle(
                              fontSize: fontSizeTitle * 0.8,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    SizedBox(width: paddingValue),
                    if ((_currentPage + 1) * _itemsPerPage <
                        diaryEntries.length)
                      ElevatedButton(
                        onPressed: () => _nextPage(diaryEntries),
                        child: Text(
                          '>',
                          style: TextStyle(
                              fontSize: fontSizeTitle * 0.8,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              ],
            );
          } else {
            return const Center(child: Text('No events found'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addEvent,
        backgroundColor: Theme.of(context).colorScheme.primary,
        icon: Icon(
          Icons.add_alert,
          color: Colors.white,
          size: fontSizeTitle,
        ),
        label: Text(
          'Add',
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSizeTitle * 0.8,
          ),
        ),
      ),
    );
  }

  void _scheduleNotification(Event event) async {
    for (String reminderType in event.reminderTypes) {
      DateTime? notificationTime;
      switch (reminderType) {
        case 'DAY_BEFORE':
          notificationTime = event.expiryDate!.subtract(Duration(days: 1));
          break;
        case 'WEEK_BEFORE':
          notificationTime = event.expiryDate!.subtract(Duration(days: 7));
          break;
        case 'MONTH_BEFORE':
          notificationTime = DateTime(event.expiryDate!.year,
              event.expiryDate!.month - 1, event.expiryDate!.day);
          break;
        case 'YEAR_BEFORE':
          notificationTime = DateTime(event.expiryDate!.year - 1,
              event.expiryDate!.month, event.expiryDate!.day);
          break;
      }

      if (notificationTime != null &&
          notificationTime.isAfter(DateTime.now())) {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          event.id,
          'Event Reminder',
          'Reminder for event: ${event.title}',
          tz.TZDateTime.from(notificationTime, tz.local),
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'event_reminder_channel',
              'Event Reminders',
              channelDescription: 'Channel for event reminders',
              importance: Importance.high,
              priority: Priority.high,
            ),
          ),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.wallClockTime,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      }
    }
  }

  void _sendDummyNotification() async {
    // Get the current time and add one minute
    DateTime now = DateTime.now();
    DateTime nextMinute = now.add(Duration(seconds: 3630));

    // Convert to TZDateTime with the local timezone
    tz.TZDateTime scheduledDate = tz.TZDateTime.from(nextMinute, tz.local);

    print("Current time: $now");
    print("Scheduled TZDateTime: $scheduledDate");

    var details = const NotificationDetails(
      android: AndroidNotificationDetails(
        'test_channel',
        'Test Notifications',
        channelDescription: 'Channel for test notifications',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Test Notification',
      'This is a test notification.',
      scheduledDate,
      details,
      payload: "New payload",
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> showNotification() async {
    var androidChannel = const AndroidNotificationDetails(
      'channel id',
      'channel name',
      channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    var iosChannel = const DarwinNotificationDetails();
    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);
    await flutterLocalNotificationsPlugin.show(
      0,
      "Defense",
      "Project Defense",
      platformChannel,
      payload: "New payload",
    );
  }
}
