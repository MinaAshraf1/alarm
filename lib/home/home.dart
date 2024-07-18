import 'package:alarm/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List alarms = [];
  TimeOfDay time = TimeOfDay.now();

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const  InitializationSettings initializationSettings =
    InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'));
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _showNotification(int index) async {
    TimeOfDay temp = alarms[index]['time'];
    final tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.getLocation('Africa/Cairo'),
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      temp.hour,
      temp.minute,
      DateTime.now().second,
      DateTime.now().millisecond,
      DateTime.now().microsecond,
    );
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'alarm',
      'alarm notification',
      // 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Alarm',
      'This is an alarm notification',
      // scheduledDate,
      platformChannelSpecifics,
      // uiLocalNotificationDateInterpretation:
      // UILocalNotificationDateInterpretation.absoluteTime,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alarm"),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold
        ),
        leading: const Icon(Icons.alarm),
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 28,
          weight: 28
        ),
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          TimeOfDay? newTime = await showTimePicker(
            context: context,
            initialTime: time,
          );
          if(newTime == null) return;
          setState(() {
            alarms.add({
              "time": newTime,
              "status": true
            });
          });
          _showNotification(alarms.length - 1);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.alarm_add,color: Colors.white,),
      ),
      body: alarms.isEmpty? const Center(
        child: Text("No Alarm Found"),
      ) : ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: alarms.length,
        itemBuilder: (context, index) => Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(5),
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              TextButton(
                child: Text(
                  "${times(alarms[index]['time'])[0]} : ${times(alarms[index]['time'])[1]} ${times(alarms[index]['time'])[2]}",
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                    color: Colors.white
                  ),
                ),
                onPressed: () async{
                  TimeOfDay? newTime = await showTimePicker(
                    context: context,
                    initialTime: time,
                  );
                  if(newTime == null) return;
                  setState(() {
                    alarms[index]['time'] = newTime;
                    alarms[index]['status'] = true;
                  });
                  _showNotification(index);
                },
              ),

              const Spacer(),

              Expanded(
                child: Switch(
                  onChanged: (val) {
                    setState(() {
                      alarms[index]['status'] = val;
                    });
                  },
                  value: alarms[index]['status'],
                ),
              ),
              
              Expanded(child: IconButton(
                onPressed: () {
                  setState(() {
                    alarms.removeAt(index);
                  });
                },
                color: Colors.black,
                icon: const Icon(Icons.delete),
              ))
            ],
          ),
        )
      )
    );
  }
}