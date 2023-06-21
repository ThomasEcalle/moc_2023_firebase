import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseRemoteConfig.instance.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(seconds: 10),
    ),
  );

  final activated = await FirebaseRemoteConfig.instance.fetchAndActivate();

  runApp(const RemoteConfigApp());
}

class RemoteConfigApp extends StatelessWidget {
  const RemoteConfigApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RemoteConfigHome(),
    );
  }
}

class RemoteConfigHome extends StatefulWidget {
  const RemoteConfigHome({Key? key}) : super(key: key);

  @override
  State<RemoteConfigHome> createState() => _RemoteConfigHomeState();
}

class _RemoteConfigHomeState extends State<RemoteConfigHome> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    final minimumBuildNumber = FirebaseRemoteConfig.instance.getInt('minimum_build_number');
    final packageInfo = await PackageInfo.fromPlatform();
    final buildNumber = int.parse(packageInfo.buildNumber);
    print('minimumBuildNumber: $minimumBuildNumber');
    print('buildNumber: $buildNumber');

    if (buildNumber < minimumBuildNumber && mounted) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Center(
            child: Container(
              height: 200,
              width: 200,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coucou'),
      ),
    );
  }
}
