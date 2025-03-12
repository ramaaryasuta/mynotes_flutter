import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/router/app_router.gr.dart';
import 'package:mynotes/services/database_provider.dart';
import 'package:mynotes/utils/dialog_utils.dart';
import 'package:mynotes/utils/snackbar.dart';
import 'package:provider/provider.dart';

import '../utils/formating_string.dart';
import '../utils/language_helper.dart';

@RoutePage()
class ViewNoteScreen extends StatelessWidget {
  const ViewNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<DatabaseProvider>();
    final note = provider.selectedNote!;

    return Scaffold(
      backgroundColor: Color(int.parse(note.color)),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.router.pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () {
                context.router.popAndPush(const CreateNoteRoute());
              },
              icon: const Icon(Icons.edit, color: Colors.white)),
          IconButton(
            onPressed: () {
              deleteDialog(context, title: note.title, onDelete: () {
                provider.deleteNote(note.id!);
                showSnackBar(context,
                    message: S.of(context)!.noteSuccessfullyDeleted);
                Navigator.pop(context); // close popup
                context.router.pop();
              });
            },
            icon: const Icon(Icons.delete, color: Colors.white),
          )
        ],
      ),
      body: Consumer<DatabaseProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            child: Column(
              spacing: 30,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note.title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                      ),
                      Row(
                        spacing: 10,
                        children: [
                          const Icon(
                            Icons.calendar_month,
                            color: Colors.white,
                            size: 30,
                          ),
                          Text(
                            formatedDate(note.dateTime, context),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height * .755),
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )),
                  child: Text(
                    note.content,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
