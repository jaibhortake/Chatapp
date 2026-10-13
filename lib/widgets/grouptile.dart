import 'package:chatme/helper/helper_function.dart';
import 'package:chatme/service/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../pages/chatpage.dart';

class GroupTile extends StatefulWidget{
  final String userName;
  final String groupId;
  final String groupName;

  const GroupTile({Key? key,
    required this.groupName,
    required this.userName,
    required this.groupId})
  : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  int lastSeen = 0;

  @override
  void initState() {
    super.initState();
    loadLastSeen();
  }

  void loadLastSeen() async {
    int value = await HelperFunction.getLastSeen(widget.groupId);
    if (mounted) {
      setState(() {
        lastSeen = value;
      });
    }
  }

  // shows a dot when the group's latest message is newer than our last visit
  Widget unreadDot() {
    return StreamBuilder<DocumentSnapshot>(
      stream: DatabaseService().getGroupStream(widget.groupId),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) return SizedBox.shrink();
        final data = snapshot.data!.data() as Map<String, dynamic>;
        int recent = int.tryParse("${data['recentMessageTime'] ?? ''}") ?? 0;
        bool unread = recent > lastSeen &&
            data['recentMessageSender'] != widget.userName;
        if (!unread) return SizedBox.shrink();
        return Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(
            userName: widget.userName,
            groupName: widget.groupName,
            groupId: widget.groupId)
        ));
        loadLastSeen();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),

        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(widget.groupName.substring(0,1).toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,fontWeight: FontWeight.w500
            ),),
          ),
          title: Text(widget.groupName,style: TextStyle(fontWeight: FontWeight.bold),),
          subtitle: Text("Join the conversation as ${widget.userName}",style: TextStyle(fontSize: 13),),
          trailing: unreadDot(),
        ),
      ),
    );

  }
}