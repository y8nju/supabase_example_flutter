import 'package:flutter/material.dart';
import 'package:supabase_example/main.dart';
import 'package:supabase_example/widgets/avatar_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _getInitialProfile();
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _websiteController.dispose();
  }

  Future<void> _getInitialProfile() async {
    final userId = supabase.auth.currentUser!.id;
    final data =
        await supabase.from('profiles').select().eq('id', userId).single();
    setState(() {
      _usernameController.text = data['username'];
      _websiteController.text = data['website'];
      _imageUrl = data['avatar_url'];
    });
  }

  Future<void> _onUpload(String imageUrl) async {
    final userId = supabase.auth.currentUser!.id;
    await supabase.from('profiles').upsert({
      'id': userId,
      'avatar_url': imageUrl,
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Updated your profile image!'),
        ),
      );
    }
    setState(() {
      _imageUrl = imageUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Account'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            AvatarWidget(imageUrl: _imageUrl, onUpload: _onUpload),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: _usernameController,
              style: const TextStyle(
                fontSize: 20,
              ),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 2,
                ),
                labelText: 'Username',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _websiteController,
              style: const TextStyle(
                fontSize: 20,
              ),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 2,
                ),
                labelText: 'Website',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                final username = _usernameController.text.trim();
                final website = _websiteController.text.trim();
                final userId = supabase.auth.currentUser!.id;
                try {
                  await supabase.from('profiles').update({
                    'username': username,
                    'website': website,
                    'updated_at': DateTime.now().toIso8601String(),
                  }).eq('id', userId);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Successfully updated profile!'),
                      ),
                    );
                  }
                } on PostgrestException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.message),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        ));
  }
}
