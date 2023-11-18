import 'package:drift/drift.dart' as dr;
import 'package:flutter/material.dart';
import 'package:flutter_moor_db/Utility/priority_picker.dart';
import 'package:flutter_moor_db/database/database.dart';
import 'package:provider/provider.dart';

class NoteDetail extends StatefulWidget {
  final String title;
  final NoteCompanion noteCompanion;

  const NoteDetail(
      {super.key, required this.title, required this.noteCompanion});

  @override
  State<StatefulWidget> createState() => NoteDetailState();
}

class NoteDetailState extends State<NoteDetail> {
  late AppDatabase database;
  late TextEditingController titleEditingController;
  late TextEditingController descriptionEditingController;
  int priorityLevel = 0;
  int colorLevel = 0;
  @override
  void initState() {
    titleEditingController = TextEditingController();
    descriptionEditingController = TextEditingController();

    titleEditingController.text = widget.noteCompanion.title.value;
    descriptionEditingController.text = widget.noteCompanion.description.value;
    priorityLevel = widget.noteCompanion.priority.value!;
    colorLevel = widget.noteCompanion.color.value!;
  }

  @override
  Widget build(BuildContext context) {
    database = Provider.of<AppDatabase>(context);
    return Scaffold(
      appBar: _getDetailAppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              PriorityPicker(priorityLevel, (selectedIndex) {
                priorityLevel = selectedIndex;
              }),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: titleEditingController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    hintText: 'Enter Title'),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: descriptionEditingController,
                maxLength: 300,
                maxLines: 8,
                minLines: 7,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    hintText: 'Enter Description'),
              )
            ],
          ),
        ),
      ),
    );
  }

  _getDetailAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(Icons.chevron_left_outlined),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        widget.title,
        style: TextStyle(color: Colors.black),
      ),
      actions: [
        IconButton(
            onPressed: () {
              _saveToDB();
            },
            icon: Icon(Icons.save)),
        IconButton(
            onPressed: () {
              _deleteNote();
            },
            icon: Icon(Icons.delete)),
      ],
    );
  }

  void _saveToDB() {
    if (widget.noteCompanion.id.present) {
      database
          .updateNote(NoteData(
              id: widget.noteCompanion.id.value,
              title: titleEditingController.text,
              description: descriptionEditingController.text,
              color: 1,
              priority: 1))
          .then((value) => {Navigator.pop(context, true)});
    } else {
      database
          .insertNote(NoteCompanion(
            title: dr.Value(titleEditingController.text),
            description: dr.Value(descriptionEditingController.text),
            priority: dr.Value(priorityLevel),
            color: dr.Value(colorLevel),
          ))
          .then((value) => {Navigator.pop(context, true)});
    }
  }

  void _deleteNote() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Note'),
          content: Text('Do you really want to delete this note.'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel')),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  database
                      .deleteNote(NoteData(
                          id: widget.noteCompanion.id.value,
                          title: widget.noteCompanion.title.value,
                          description: widget.noteCompanion.description.value))
                      .then((value) => {Navigator.pop(context, true)});
                },
                child: Text('Delete')),
          ],
        );
      },
    );
  }
}
