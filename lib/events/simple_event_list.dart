import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hope_admin/events/get_eventgroup_name.dart';


class SimpleEventList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Note: as of 15-may-2021 we have
    // https://hopeww.volunteerhub.com/lp/dfw/event/2009e9ca-6fdd-495a-861e-2345338c6977 as june 12
    // https://hopeww.volunteerhub.com/lp/dfw/event/8e7d6370-fc1a-46a9-8887-e6f52cb15c9d as june 14
    // adn these can shown by filtering by may 5 to june 19 on "denton" event id
    String denton = eventGroupIds[3];
    DateTime may5 = DateTime(2021, 5,15);
    DateTime june19 = DateTime(2021,6,19);
    CollectionReference events = FirebaseFirestore.instance.collection('events_test_batch').doc(denton).collection("events");
    //Stream collectionStream = FirebaseFirestore.instance.collection('users').snapshots();
    //Stream documentStream = FirebaseFirestore.instance.collection('users').doc('ABC123').snapshots();
    //      stream: events.where('StartDate', isGreaterThanOrEqualTo: "2021-04-17T08:00:00").snapshots(),
    return StreamBuilder<QuerySnapshot>(
      stream: events.where('StartDateTime', isGreaterThanOrEqualTo: may5,
          isLessThanOrEqualTo: june19
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
            return new ListTile(
              title: new Text(document.data()!['Name'] + document.data()!['StartTime']),
              subtitle: new Text(document.data()!['ShortDescription']),
            );
          }).toList(),
        );
      },
    );
  }
}