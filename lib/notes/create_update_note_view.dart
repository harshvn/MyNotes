import 'package:flutter/material.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/services/cloud/cloud_storage.dart';
import 'package:notes/utlities/generics/get_arguments.dart';
import 'package:notes/services/cloud/cloud_note.dart';

class createupdatenoteview extends StatefulWidget {
  const createupdatenoteview({super.key});

  @override
  State<createupdatenoteview> createState() => _createupdatenoteviewState();
}

class _createupdatenoteviewState extends State<createupdatenoteview> {
  @override
  void initState() {
    _noteService = FirebaseCloudStorage();
    _textControlloer = TextEditingController();
    super.initState();
  }

  CloudNote? _note;
  late final FirebaseCloudStorage _noteService;
  late final TextEditingController _textControlloer;
  Future<CloudNote> createnewnote(BuildContext context) async {
    final widgetNode = context.get_arguments<CloudNote>();
    if (widgetNode != null) {
      _note = widgetNode;
      _textControlloer.text = widgetNode.text;
      return widgetNode;
    }

    final existingnote = _note;
    if (existingnote != null) return existingnote;
    final currentuser = AuthService.firebase().currentUser;
    final email = currentuser!.email;
    final user = currentuser.id;
    final newnote = await _noteService.createNewNote(ownerUserId: user);
    _note = newnote;
    return newnote;
  }

  void _textControllerListner() async {
    final note = _note;
    if (note == null) return;
    final text = _textControlloer.text;
    final id = note.documentId;
    await _noteService.updateNote(documentId: id, text: text);
  }

  void _setuptextcontroller() {
    _textControlloer.removeListener(_textControllerListner);
    _textControlloer.addListener(_textControllerListner);
  }

  void _deleteNoteIfTextempty() {
    final note = _note;
    if (_textControlloer.text.isEmpty && note != null) {
      final id = note.documentId;
      _noteService.deleteNode(documentId: id);
    }
  }

  void _savenoteiftextisnotempty() async {
    final note = _note;
    final id = note?.documentId;
    final text = _textControlloer.text;
    if (note != null && text.isNotEmpty) {
      await _noteService.updateNote(documentId: id!, text: text);
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextempty();
    _savenoteiftextisnotempty();
    createnewnote(context);
    _textControlloer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Note')),
      body: FutureBuilder<CloudNote>(
        future: createnewnote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(child: Text('Note could not be created.'));
              }
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
