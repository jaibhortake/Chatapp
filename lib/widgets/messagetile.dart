import 'package:flutter/material.dart';

class MessageTile extends StatefulWidget{
  final String message;
  final String sender;
  final bool sentByMe;
  final int? time; // microseconds since epoch

const MessageTile({Key? key, required this.message,required this.sender,required this.sentByMe, this.time})
  : super(key: key);
  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  String formatTime(int micros) {
    DateTime t = DateTime.fromMicrosecondsSinceEpoch(micros);
    String two(int n) => n.toString().padLeft(2, '0');
    return "${two(t.hour)}:${two(t.minute)}";
  }

  @override
  Widget build(BuildContext context){
    Color textColor = widget.sentByMe ? Colors.white : Colors.black;
    return Container(
      padding: EdgeInsets.only(top: 4,bottom: 4,
          left: widget.sentByMe? 0:24,
          right: widget.sentByMe?24:0),
      alignment: widget.sentByMe? Alignment.centerRight:Alignment.centerLeft,
      child: Container(
        margin: widget.sentByMe? EdgeInsets.only(left: 30): EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 12,left: 20,right: 20),
        decoration: BoxDecoration(
          borderRadius: widget.sentByMe?
          BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight:  Radius.circular(20),
            bottomLeft:  Radius.circular(20),
             )
              : BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight:  Radius.circular(20),
             bottomRight:  Radius.circular(20),
          ),
          color: widget.sentByMe? Theme.of(context).primaryColor : Color(0xFFEDECF4)
        ),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Text(widget.sender.toUpperCase(),
               style: TextStyle(fontSize: 13,
                   fontWeight: FontWeight.w500,
                   color: textColor,
                   letterSpacing:-0.1)
           ),
           SizedBox(height: 8,),
           Text(widget.message, style: TextStyle(fontSize: 16,color: textColor),),
           if (widget.time != null) ...[
             SizedBox(height: 6,),
             Text(formatTime(widget.time!),
                 style: TextStyle(fontSize: 11, color: textColor.withOpacity(0.7))),
           ],
         ],
       ),
      ),
    );

  }
}
