import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/main.dart';
import 'package:notes/notes/notes_list_view.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/services/cloud/cloud_note.dart';
import 'package:notes/services/cloud/cloud_storage.dart';
import 'package:notes/services/crud/note_service.dart';
import 'package:notes/utlities/showerror.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _noteService;
  String get userId => AuthService.firebase().currentUser!.id;
  @override
  void initState() {
    _noteService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Notes"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(newnotesroute);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldlogout = await showLogOutDialog(context);
                  if (shouldlogout) {
                    await FirebaseAuth.instance.signOut();
                    // await FirebaseAuth.instance.setPersistence(
                    //   Persistence.NONE,
                    // );

                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil(loginroute, (_) => false);
                  }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: const Text('Log out'),
                ),
              ];
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _noteService.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allnotes = snapshot.data as Iterable<CloudNote>;
                return NotesListView(
                  onDeleteNote: (note) async {
                    await _noteService.deleteNode(documentId: note.documentId);
                  },
                  notes: allnotes,
                  onTap: (note) {
                    Navigator.of(
                      context,
                    ).pushNamed(newnotesroute, arguments: note);
                  },
                );
              } else {
                return const Text('hello');
              }
            default:
              return const Text('hello');
          }
        },
      ),
    );
  }
}
