import 'package:firebase_analytics/firebase_analytics.dart';

FirebaseAnalytics analytics = FirebaseAnalytics.instance;

void customEvents (String name, Map<String, Object> parameter){
  final Map<String, Object> updatedParams = Map.from(parameter);

  updatedParams['time'] = DateTime.now().toUtc().millisecondsSinceEpoch;
  
  analytics.logEvent(
      name: name,
      parameters: updatedParams
  );
}