import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GetEventGroupNames extends StatefulWidget {
  @override
  _GetEventGroupNamesState createState() => _GetEventGroupNamesState();
}

class _GetEventGroupNamesState extends State<GetEventGroupNames> {
  @override
  Widget build(BuildContext context) {
    int itemCount = eventGroupIds.length;
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
           return ListTile(
             title: GetEventGroupName(eventGroupIds[index]),
           );
         },
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemCount: itemCount);
  }
}

class GetEventGroupName extends StatelessWidget {
  final String documentId;

  GetEventGroupName(this.documentId);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('events_test_batch');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document $documentId not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          String name =  snapshot.data!.get('Name');
          return Text("Event Group Name: $name ");
        }

        return Text("loading");
      },
    );
  }
}
// this still isn't quite public, and it's obscure

List<String> eventGroupIds = ["f22bf977-d178-41bb-9283-6da8e6804bbb",
    "c2b2ab99-5ede-4b8e-866d-a30700981ea7",
    "c292f574-ff22-4b7a-9d9b-2e9b68b12206",
    "c1f81d0b-e214-49ec-b17f-e07c4e07ece8",
        "12072701-32cc-43c1-9ba7-36aa513274f5",
    "4edffcea-57d5-445d-b044-46f63f9164d7",
    "be4baa6b-eaae-4492-a130-072238e4c286",
    "af07aeb9-12cc-44ef-9d45-6504cb1183b1",
    "09ce9166-fdf5-4a28-9747-1f8eac3abd6f",
    "564c83c7-3ad3-4ccb-aed8-9d2490c0de9b"];

// name "dallas fort worth is f22bf977-d178-41bb-9283-6da8e6804bbb wiht parentid 066d3d70-4618-4bba-82f6-b721717d31f6
// texas is 066d3d70-4618-4bba-82f6-b721717d31f6 with parent is 55b92780-abc2-4bc0-93e2-c3c3d9b9c2c5
// f22bf977-d178-41bb-9283-6da8e6804bbb has only one child c2b2ab99-5ede-4b8e-866d-a30700981ea7 whihc is Dallas fort worth public events - has only one child
// and has a lot of events


