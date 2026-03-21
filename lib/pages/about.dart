import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

void showAboutDialog({required BuildContext context}) {
  showDialog<void>(
    context: context,
    builder: (context) {
      return _AboutDialog();
    },
  );
}

Future<String> getVersionNumber() async {
  final packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}

class _AboutDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bodyTextStyle = textTheme.bodyLarge!.apply(
      color: colorScheme.onPrimary,
    );

    return AlertDialog(
      title: FutureBuilder<String>(
        future: getVersionNumber(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text('App Version: ${snapshot.data}');
          }
          return const Text('App Version: Loading...');
        },
      ),
      content: Text('About this app.', style: bodyTextStyle),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
