import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:moc_firebase/analytics/analytics_handler.dart';

class FirebaseAnalyticsHandler extends AnalyticsHandler {
  @override
  Future<void> logEvent(String name, Map<String, dynamic> parameters) {
    return FirebaseAnalytics.instance.logEvent(name: name, parameters: parameters);
  }

  @override
  Future<void> setUserProperty(String name, String value) {
    return FirebaseAnalytics.instance.setUserProperty(name: name, value: value);
  }
}
