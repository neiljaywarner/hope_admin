
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:hope_admin/events/get_eventgroup_name.dart';


class SimpleEventList extends StatelessWidget {
  final DateTime fromDate;
  final DateTime toDate;

  const SimpleEventList({Key? key, required this.fromDate, required this.toDate}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //Note: as of 15-may-2021 we have
    // https://hopeww.volunteerhub.com/lp/dfw/event/2009e9ca-6fdd-495a-861e-2345338c6977 as june 12
    // https://hopeww.volunteerhub.com/lp/dfw/event/8e7d6370-fc1a-46a9-8887-e6f52cb15c9d as june 14
    // adn these can shown by filtering by may 5 to june 19 on "denton" event id
    String denton = eventGroupIds[3];

    CollectionReference events = FirebaseFirestore.instance.collection('events_test_batch').doc(denton).collection("events");
    //Stream collectionStream = FirebaseFirestore.instance.collection('users').snapshots();
    //Stream documentStream = FirebaseFirestore.instance.collection('users').doc('ABC123').snapshots();
    //      stream: events.where('StartDate', isGreaterThanOrEqualTo: "2021-04-17T08:00:00").snapshots(),
    return EventListWidget(events: events, fromDate: fromDate, toDate: toDate);
  }
}

class EventListWidget extends StatelessWidget {
  const EventListWidget({
    Key? key,
    required this.events,
    required this.fromDate,
    required this.toDate,
  }) : super(key: key);

  final CollectionReference<Object?> events;
  final DateTime fromDate;
  final DateTime toDate;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: events.where('StartDateTime', isGreaterThanOrEqualTo: fromDate,
          isLessThanOrEqualTo: toDate
      ).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return new ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            String name = document.get('Name');
            Timestamp timestamp = document.get('StartDateTime');
            DateTime startDate = timestamp.toDate();
            String dateString = startDate.toLocal().toString();
            String shortDescription = document.get('ShortDescription');
            // TODO: With html
            return new ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  new Text(name),
                  new Text(dateString.substring(0, dateString.lastIndexOf(":")))
                ],
              ),
              subtitle: new HtmlWidget(shortDescription),
            );
          }).toList(),
        );
      },
    );
  }
}