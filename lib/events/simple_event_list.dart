import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hope_admin/events/get_eventgroup_name.dart';


class SimpleEventList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('events_test_batch').doc(eventGroupIds[1]).collection("events");
    //Stream collectionStream = FirebaseFirestore.instance.collection('users').snapshots();
    //Stream documentStream = FirebaseFirestore.instance.collection('users').doc('ABC123').snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: users.snapshots(),
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