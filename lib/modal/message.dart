import 'package:chatsen/widgets/channel_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/tile.dart';
import '../tmi/channel/messages/channel_message_chat.dart';
import '../widgets/chat_message.dart';

class MessageModal extends StatelessWidget {
  final ChannelMessageChat message;
  final ChannelViewState? channelViewState;

  const MessageModal({
    super.key,
    required this.message,
    this.channelViewState,
  });

  @override
  Widget build(BuildContext context) => ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ChatMessage(message: message),
          ),
          Tile(
            title: 'Reply',
            prefix: const Icon(Icons.reply_outlined),
            onTap: () {
              Navigator.of(context).pop();
              channelViewState?.setReplyChannelMessageChat(message);
            },
          ),
          Tile(
            title: 'Copy text',
            subtitle: 'Hold to copy message text with username',
            prefix: const Icon(Icons.copy_rounded),
            onTap: () async {
              Navigator.of(context).pop();
              await Clipboard.setData(ClipboardData(text: message.body));
            },
            onLongPress: () async {
              Navigator.of(context).pop();
              await Clipboard.setData(ClipboardData(text: '${message.dateTime.hour}:${message.dateTime.minute.toString().padLeft(2, '0')} ${message.user.displayName}: ${message.body}'));
            },
          ),
          Tile(
            title: 'Delete message',
            prefix: const Icon(Icons.delete_outline_outlined),
            onTap: () async {
              Navigator.of(context).pop();
              await message.channel?.send('/delete ${message.id}');
            },
          ),
          Tile(
            title: 'Mention',
            prefix: const Icon(Icons.alternate_email_outlined),
            onTap: () {
              Navigator.of(context).pop();
              channelViewState?.addSplit('@${message.user.login}');
            },
          ),
          Tile(
            title: 'Copy message ID',
            prefix: const Icon(Icons.medical_information_outlined),
            onTap: () async {
              Navigator.of(context).pop();
              await Clipboard.setData(ClipboardData(text: message.id));
            },
          ),
        ],
      );
}