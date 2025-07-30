import 'package:flutter/material.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/services/crud/note_service.dart';

class NewNotesView extends StatefulWidget {
  const NewNotesView({super.key});

  @override
  State<NewNotesView> createState() => _NewNotesViewState();
}

class _NewNotesViewState extends State<NewNotesView> {
  @override
  void initState() {
    _noteService = NoteService();
    _textControlloer = TextEditingController();
    super.initState();
  }

  DatabaseNote? _note;
  late final NoteService _noteService;
  late final TextEditingController _textControlloer;
  Future<DatabaseNote> createnewnote() async {
    final existingnote = _note;
    if (existingnote != null) return existingnote;
    final currentuser = AuthService.firebase().currentUser;
    final email = currentuser!.email;
    final owner = await _noteService.getOrCreateUser(email: email);
    return await _noteService.createNote(owner: owner);
  }

  void _textControllerListner() async {
    final note = _note;
    if (note == null) return;
    final text = _textControlloer.text;
    await _noteService.updateNote(note: note, text: text);
  }

  void _setuptextcontroller() {
    _textControlloer.removeListener(_textControllerListner);
    _textControlloer.addListener(_textControllerListner);
  }

  void _deleteNoteIfTextempty() {
    final note = _note;
    if (_textControlloer.text.isEmpty && note != null) {
      _noteService.deleteNote(id: note.id);
    }
  }

  void _savenoteiftextisnotempty() async {
    final note = _note;
    final text = _textControlloer.text;
    if (note != null && text.isNotEmpty) {
      await _noteService.updateNote(note: note, text: text);
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextempty();
    _savenoteiftextisnotempty();
    createnewnote();
    _textControlloer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Note')),
      body: FutureBuilder<DatabaseNote>(
        future: createnewnote(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(child: Text('Note could not be created.'));
              }
              _note = snapshot.data!;
              _setuptextcontroller();
              return TextField(
                controller: _textControlloer,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Start typing your note...',
                ),
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
