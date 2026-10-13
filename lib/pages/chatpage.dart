import 'package:chatme/helper/helper_function.dart';
import 'package:chatme/pages/groupinfo.dart';
import 'package:chatme/service/database_service.dart';
import 'package:chatme/widgets/messagetile.dart';
import 'package:chatme/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget{
  final String groupId;
  final String groupName;
  final String userName;

  const ChatPage({Key? key,
    required this.userName,
    required this.groupName,
    required this.groupId}) :super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  String admin = "" ;
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getChatandAdmin();
    markSeen();
  }

  @override
  void dispose() {
    markSeen();
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  // remember when this group was last opened, so the home page can show unread dots
  void markSeen() {
    HelperFunction.saveLastSeen(widget.groupId, DateTime.now().microsecondsSinceEpoch);
  }

  getChatandAdmin() {
    DatabaseService().getChats(widget.groupId).then((val){
      setState(() {
        chats = val;
      });

    });
    DatabaseService().getGroupAdmin(widget.groupId).then((val){
      setState(() {
        admin = val;

      });
    });
  }


  Widget build(BuildContext context){
    return Scaffold(
     appBar: AppBar(
       centerTitle: true,
       elevation: 0,
       title: Text(widget.groupName,style: TextStyle(color: Colors.white),),
       backgroundColor: Theme.of(context).primaryColor,
       actions: [
         IconButton(onPressed: (){
           nextScreen(context, GroupInfo(
               groupName: widget.groupName,
               groupId: widget.groupId,
               adminName: admin));
         }, icon: Icon(Icons.info,color: Colors.white,))
       ],
     ),
      body: Stack(
        children: <Widget> [
          //chat messages here
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
          width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 18,horizontal: 20),
              width: MediaQuery.of(context).size.width,
              color: Color(0xFFEDECF4),
              child: Row(
                children: [
                  Expanded(child: TextFormField(
                    controller: messageController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "Send a message.....",
                      hintStyle: TextStyle(color: Colors.black,fontSize: 16),
                      border: InputBorder.none,
                    ),
                  )),
                 SizedBox(width: 12),
                  GestureDetector(
                    onTap: (){
                      sendMessage();
                    },
                    child: Container(
                      height: 50, width: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(Icons.send,color: Colors.white,),
                    ),
                  )
                ],),
            ),

          )


        ],
      ),
    );

  }
  // read the message time safely (older messages may not have one)
  int? messageTime(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final t = data['time'];
    return t is int ? t : null;
  }

  String dayLabel(int micros) {
    DateTime t = DateTime.fromMicrosecondsSinceEpoch(micros);
    DateTime now = DateTime.now();
    DateTime day = DateTime(t.year, t.month, t.day);
    DateTime today = DateTime(now.year, now.month, now.day);
    int diff = today.difference(day).inDays;
    if (diff == 0) return "Today";
    if (diff == 1) return "Yesterday";
    return "${t.day}/${t.month}/${t.year}";
  }

  Widget dayDivider(String label) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          decoration: BoxDecoration(
            color: Color(0xFFEDECF4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(label, style: TextStyle(fontSize: 12, color: Colors.black54)),
        ),
      ),
    );
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }

  chatMessages(){
    return StreamBuilder(
        stream: chats,
        builder: (context,AsyncSnapshot snapshot){
          if (!snapshot.hasData) return Container();
          final docs = snapshot.data.docs as List<QueryDocumentSnapshot>;
          scrollToBottom();
          return ListView.builder(
            controller: scrollController,
            // leave room so the last message is not hidden behind the input bar
            padding: EdgeInsets.only(top: 8, bottom: 100),
            itemCount: docs.length,
              itemBuilder: (context,index){
               final data = docs[index].data() as Map<String, dynamic>;
               final time = messageTime(docs[index]);
               final prevTime = index > 0 ? messageTime(docs[index - 1]) : null;
               bool showDivider = time != null &&
                   (prevTime == null || dayLabel(time) != dayLabel(prevTime));
               final tile = MessageTile(
                   message: data['message'] ?? "",
                   sender: data['sender'] ?? "",
                   sentByMe: widget.userName==data['sender'],
                   time: time);
               if (!showDivider) return tile;
               return Column(children: [dayDivider(dayLabel(time)), tile]);
              }
          );
        }

    );
  }
  sendMessage(){
    if(messageController.text.isNotEmpty){
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time" : DateTime.now().microsecondsSinceEpoch,

      };
      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }

  }
}