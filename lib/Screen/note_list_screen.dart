import 'package:drift/drift.dart' as dr;
import 'package:flutter/material.dart';
import 'package:flutter_moor_db/Screen/note_detail_screen.dart';
import 'package:flutter_moor_db/database/database.dart';
import 'package:provider/provider.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NoteListState();
}

class NoteListState extends State<NoteList> {
  late AppDatabase database;
  late List<NoteData> noteList;
  @override
  Widget build(BuildContext context) {
    database = Provider.of<AppDatabase>(context);
    return Scaffold(
      appBar: _getNoteListAppBar(),
      body: FutureBuilder<List<NoteData>>(
        future: _getNoteFromDatabase(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<NoteData>? noteList = snapshot.data;
            if (noteList != null) {
              if (noteList.isEmpty) {
                return Center(
                  child: Text(
                    'No notes found',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                );
              } else {
                return noteListUI(noteList);
              }
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: Theme.of(context).textTheme.titleSmall,
              ),
            );
          }
          return Center(
            child: Text(
              'Click on add btn to add new note',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToDetail(
              'Add Note',
              NoteCompanion(
                  title: dr.Value(''),
                  description: dr.Value(''),
                  color: dr.Value(0),
                  priority: dr.Value(0)));
        },
        shape: CircleBorder(side: BorderSide(color: Colors.black, width: 2)),
        backgroundColor: Colors.white,
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }

  Future<List<NoteData>> _getNoteFromDatabase() {
    return database.getNoteList();
  }

  Widget noteListUI(List<NoteData> noteList) {
    return GridView.builder(
        itemCount: noteList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns
          // mainAxisExtent: MediaQuery.of(context).size.height * 0.2,
          // Horizontal spacing between items
          // Vertical spacing between items
        ),
        itemBuilder: (context, index) {
          NoteData noteData = noteList[index];
          return InkWell(
            onTap: () {
              _navigateToDetail(
                'Edit Note',
                NoteCompanion(
                  id: dr.Value(noteData.id),
                  title: dr.Value(noteData.title),
                  description: dr.Value(noteData.description),
                  priority: dr.Value(noteData.priority),
                  color: dr.Value(noteData.color),
                ),
              );
            },
            child: Container(

                // margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.black)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(noteData.title),
                        Text(_getPriority(noteData.priority!))
                      ],
                    ),
                    Text(noteData.description),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '11/09/2000',
                          style: Theme.of(context).textTheme.titleSmall,
                        )
                      ],
                    )
                  ],
                )),
          );
        });
  }

  _navigateToDetail(String _title, NoteCompanion _noteCompanion) async {
    var res = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NoteDetail(
            title: _title,
            noteCompanion: _noteCompanion,
          ),
        ));
    if (res != null && res == true) {
      setState(() {});
    }
  }

  String _getPriority(int p) {
    switch (p) {
      case 2:
        return '!!!';
      case 1:
        return '!!';
      default:
        return '!';
    }
  }

  _getNoteListAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        'Notes',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      centerTitle: true,
      actions: [
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.list,
              // color: Colors.black,
            ))
      ],
    );
  }
}
