import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/models/notes_model.dart';
import 'package:mynotes/utils/formating_string.dart';
import 'package:mynotes/utils/language_helper.dart';
import 'package:provider/provider.dart';

import '../components/my_drawer.dart';
import '../router/app_router.gr.dart';
import '../services/database_provider.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchNoteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      Provider.of<DatabaseProvider>(context, listen: false).getNotes,
    );
  }

  @override
  void dispose() {
    searchNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.myNotes),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: NoteSearchDelegate(),
              );
            },
            icon: const Icon(Icons.search_rounded),
          )
        ],
      ),
      drawer: const MyDrawer(),
      body: Consumer<DatabaseProvider>(
        builder: (context, provider, child) {
          final note = provider.note;

          if (note.isEmpty) {
            return Center(
              child: Column(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.edit_note_rounded,
                    size: 50,
                  ),
                  Text(
                    S.of(context)!.noNotes,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(15),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemCount: note.length,
            itemBuilder: (context, index) {
              final noteData = note[index];
              final color = Color(int.parse(noteData.color));
              return GestureDetector(
                onTap: () {
                  provider.selectNote(noteData);
                  context.router.push(const ViewNoteRoute());
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(0, 3))
                      ]),
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(noteData.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                      Expanded(
                        child: Text(noteData.content,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.white)),
                      ),
                      Text(
                        formatedDate(noteData.dateTime, context),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<DatabaseProvider>().unSelectNote();
          context.router.push(const CreateNoteRoute());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NoteSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Note>>(
      future: Provider.of<DatabaseProvider>(context, listen: false)
          .searchNotes(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text(S.of(context)!.notFound));
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: const Icon(Icons.file_copy_rounded),
              title: Text(
                snapshot.data![index].title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                snapshot.data![index].content,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                close(context, snapshot.data![index]);
                context
                    .read<DatabaseProvider>()
                    .selectNote(snapshot.data![index]);
                context.router.push(const ViewNoteRoute());
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
