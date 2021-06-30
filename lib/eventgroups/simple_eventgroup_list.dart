
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:hope_admin/events/get_eventgroup_name.dart';


class SimpleEventGroupList extends StatelessWidget {


  const SimpleEventGroupList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //Note: as of 15-may-2021 we have
    // https://hopeww.volunteerhub.com/lp/dfw/event/2009e9ca-6fdd-495a-861e-2345338c6977 as june 12
    // https://hopeww.volunteerhub.com/lp/dfw/event/8e7d6370-fc1a-46a9-8887-e6f52cb15c9d as june 14
    // adn these can shown by filtering by may 5 to june 19 on "denton" event id
    String denton = eventGroupIds[3];
    // showing tyler something
    CollectionReference eventGroups = FirebaseFirestore.instance.collection('events_test_batch');
    // display evnet grups
    return Scaffold(
      appBar: AppBar(title: Text("Event Groups"),),
        body: EventGroupListWidget(eventGroups: eventGroups));
  }
}

class EventGroupListWidget extends StatelessWidget {
  const EventGroupListWidget({
    Key? key,
    required this.eventGroups,
  }) : super(key: key);

  final CollectionReference<Object?> eventGroups;


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      //stream: eventGroups.where('ParentEventGroupId', isEqualTo: "28c33c75-c619-4bdd-b1e2-74e75d4f6cdc").orderBy("Name").snapshots(),
      stream: eventGroups.orderBy("Name").snapshots(),
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

            return ListTile(title: Text(name));
          }).toList(),
        );
      },
    );
  }
}