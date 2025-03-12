import 'package:flutter/material.dart';
import 'package:mynotes/models/notes_model.dart';
import 'database_service.dart';

class DatabaseProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();

  List<Note> _note = [];
  final List<Color> _noteColor = [
    Colors.amber,
    Colors.redAccent,
    Colors.pink,
    Colors.blueAccent,
    Colors.indigo,
    Colors.indigoAccent,
    Colors.deepPurpleAccent,
    Colors.green,
  ];
  Note? _selectedNote;

  List<Note> get note => _note;
  List<Color> get noteColor => _noteColor;
  Note? get selectedNote => _selectedNote;

  Future<void> getNotes() async {
    _note = await _databaseService.getNotes();
    notifyListeners();
  }

  void selectNote(Note? note) {
    _selectedNote = note;
    notifyListeners();
  }

  void unSelectNote() {
    _selectedNote = null;
    notifyListeners();
  }

  Future<void> insertNote(Note note) async {
    await _databaseService.insertNote(note);
    await getNotes();
  }

  Future<void> updateNote(Note note) async {
    await _databaseService.updateNote(note);
    unSelectNote();
    await getNotes();
  }

  Future<void> deleteNote(int id) async {
    await _databaseService.deleteNote(id);
    unSelectNote();
    await getNotes();
  }

  Future<List<Note>> searchNotes(String query) async {
    final searchNote = await _databaseService.searchNote(query);
    return searchNote;
  }
}
