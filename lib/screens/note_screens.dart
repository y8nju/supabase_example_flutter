import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NoteScreen extends StatelessWidget {
  NoteScreen({super.key});

  final TextEditingController _textFieldController = TextEditingController();
  final _noteStream =
      Supabase.instance.client.from('notes').stream(primaryKey: ['id']);

  Future<dynamic> _addNoteDialog(context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add a Note'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(
              hintText: 'new note',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                await Supabase.instance.client
                    .from('notes')
                    .insert({'body': _textFieldController.text});
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _noteStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final notes = snapshot.data!;
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(notes[index]['body']),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addNoteDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
