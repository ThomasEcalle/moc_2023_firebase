import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moc_firebase/analytics/analytics_provider.dart';

import 'analytics/firebase_analytics_handler.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AnalyticsProvider(
      handlers: [
        FirebaseAnalyticsHandler(),
      ],
      child: MaterialApp(
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  void _init() async {
    // await FirebaseCrashlytics.instance.setUserIdentifier('mon_user_id');
    // if (mounted) {
    //   await AnalyticsProvider.of(context).setUserProperty('user_name', 'Thomas');
    // }
    // if (mounted) {
    //   await AnalyticsProvider.of(context).setUserProperty('user_height', '183');
    // }
  }

  void _incrementCounter() async {
    await AnalyticsProvider.of(context).logEvent('counter_incremented', {'counter_value': _counter});

    setState(() {
      _counter++;
    });
  }

  void _crash() async {
    try {
      throw Exception('Coucou, ce crash est géré');
    } catch (error, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }
  }

  void _testFirestore() async {
    final CollectionReference collectionReference = FirebaseFirestore.instance.collection('users');

    try {
      //final DocumentReference documentReference = await collectionReference.add({'name': 'Bob', 'age': 30});
      //await collectionReference.doc('toto').set({'name': 'toto', 'age': 25});
      //await FirebaseFirestore.instance.collection('users/toto/pets').add({'name': 'Milou'});
      //await collectionReference.doc('toto').update({'name': 'Bernard'});

      // final userReference = await collectionReference.doc('toto').get();
      // debugPrint('User data: ${userReference.data()}');
      //
      // final ref = await collectionReference.get();
      // debugPrint('Collection data: ${ref.docs}');

      // await collectionReference.doc('toto').delete();

      //debugPrint('Document added with id: ${documentReference.id}');
    } catch (error) {
      debugPrint('Error writting in firestore: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: const Icon(Icons.cloud),
            onPressed: _testFirestore,
          ),
          FloatingActionButton(
            onPressed: _crash,
            tooltip: 'Crash',
            child: const Icon(Icons.car_crash),
          ),
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
