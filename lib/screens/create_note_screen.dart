import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/models/notes_model.dart';
import 'package:mynotes/utils/language_helper.dart';
import 'package:mynotes/utils/snackbar.dart';
import 'package:provider/provider.dart';

import '../router/app_router.gr.dart';
import '../services/database_provider.dart';

@RoutePage()
class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  Color selectedColor = Colors.amber;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    final note = provider.selectedNote;

    if (note != null) {
      _titleController.text = note.title;
      _contentController.text = note.content;
      selectedColor = Color(int.parse(note.color));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    final isEditing = provider.selectedNote != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            isEditing ? S.of(context)!.editNote : S.of(context)!.createNote),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              spacing: 20,
              children: [
                TextFormField(
                  controller: _titleController,
                  maxLines: 1,
                  decoration: InputDecoration(
                      hintText: S.of(context)!.title,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return S.of(context)!.pleaseEnterATitle;
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _contentController,
                  maxLines: 14,
                  decoration: InputDecoration(
                      hintText: S.of(context)!.content,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return S.of(context)!.pleaseEnterAContent;
                    }
                    return null;
                  },
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 15,
                      children: provider.noteColor.map((color) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedColor = color;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: selectedColor == color
                                      ? Colors.black45
                                      : Colors.transparent,
                                  width: 3,
                                )),
                            child: Container(
                              width: 25,
                              height: 25,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () {
                      saveNote();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(S.of(context)!.saveNote),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveNote() async {
    final dbProvider = context.read<DatabaseProvider>();
    if (_formKey.currentState!.validate()) {
      final note = Note(
        id: dbProvider.selectedNote?.id,
        title: _titleController.text,
        content: _contentController.text,
        color: selectedColor.value.toInt().toString(),
        dateTime: DateTime.now().toString(),
      );

      if (dbProvider.selectedNote == null) {
        await dbProvider.insertNote(note);
      } else {
        await dbProvider.updateNote(note);
        dbProvider.selectNote(note);
      }

      if (mounted) {
        showSnackBar(context,
            message: dbProvider.selectedNote != null
                ? S.of(context)!.noteSuccessfullyUpdated
                : S.of(context)!.noteSuccessfullyCreate);

        if (dbProvider.selectedNote != null) {
          // back to view mode if updating
          context.router.popAndPush(const ViewNoteRoute());
        } else {
          // to home menu
          context.router.pop();
        }
      }
    }
  }
}
