import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:mynotes/services/locale_provider.dart';
import 'package:mynotes/utils/language_helper.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              onTap: () {
                final localeProv = context.read<LocaleProvider>();

                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: Container(
                        constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * .6),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              S.of(context)!.chooseLanguage,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    AppLocalizations.supportedLocales.length,
                                itemBuilder: (context, index) {
                                  final data =
                                      AppLocalizations.supportedLocales[index];

                                  bool isActiveLocale = localeProv.locale ==
                                      Locale(data.languageCode);

                                  return ListTile(
                                      onTap: () {
                                        localeProv.setLocale(data.languageCode);
                                        Navigator.pop(context);
                                      },
                                      tileColor: isActiveLocale
                                          ? Colors.blueAccent
                                          : Colors.transparent,
                                      title: Text(
                                        localeProv.localeSupport[index],
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                color: isActiveLocale
                                                    ? Colors.white
                                                    : Colors.black),
                                      ),
                                      subtitle: Text(
                                        data.languageCode,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                color: isActiveLocale
                                                    ? Colors.white
                                                    : Colors.black),
                                      ),
                                      trailing: isActiveLocale
                                          ? const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                            )
                                          : null);
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              leading: const Icon(Icons.language_rounded),
              title: Text(S.of(context)!.changeLanguage),
            )
          ],
        ),
      ),
    );
  }
}
