import 'package:flutter/material.dart';
import 'package:projet_appli_ynov/model/message.dart';

class ReplyMessageWidget extends StatelessWidget {
  final Message message;
  VoidCallback? onCancelReply;
/*
  final VoidCallback onCancelReply;
*/

   ReplyMessageWidget({
    required this.message,
    VoidCallback? this.onCancelReply,
  });

  @override
  Widget build(BuildContext context) => IntrinsicHeight(

    child: Row(
      children: [
        Container(
          color: Colors.green,
          width: 4,
        ),
        const SizedBox(width: 8),
        Expanded(child: buildReplyMessage()),
      ],
    ),
  );

  Widget buildReplyMessage() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              '${message.name}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          if (onCancelReply != null)
            GestureDetector(
              child: Icon(Icons.close, size: 16),
              onTap: onCancelReply,
            )
        ],
      ),
      const SizedBox(height: 8),
      Text(message.message, style: TextStyle(color: Colors.black54)),
    ],
  );
}
