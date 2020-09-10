import 'package:agendacontatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ContactHelper helper = ContactHelper();

  @override
  void initState() {
    super.initState();
   Contact c = Contact();
    c.name = "Daniel Ciolfi";
    c.email = "daniel@gmail.com";
    c.phone = "5533664455";
    c.img = "imgtest";

    helper.saveContact(c);
    helper.getAllContacts().then((list){
      print(list);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}