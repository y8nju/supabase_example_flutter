import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final stream = Supabase.instance.client
      .from('messages')
      .stream(primaryKey: ['id'])
      .eq('room_id', 1)
      .order('created_at')
      .limit(20);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Message'),
          centerTitle: true,
        ),
        body: Container());
  }
}
