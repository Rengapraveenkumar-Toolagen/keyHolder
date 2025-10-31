import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import './bloc/application_bloc_observer.dart';
import './bloc/bloc.dart';
import './l10n/l10n.dart';
import './presentation/routes/pages_name.dart';
import './presentation/routes/routes.dart';
import './utils/utils.dart';
import 'l10n/app_localizations.dart';

void mainApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  Bloc.observer = ApplicationBlocObserver();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    super.initState();
    analytics.setAnalyticsCollectionEnabled(true);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return ScreenUtilInit(
        designSize: Size(width, height),
        minTextAdapt: true,
        splitScreenMode: true,
        useInheritedMediaQuery: true,
        builder: (context, child) {
          ScreenUtil.init(context);
          return MultiBlocProvider(
              providers: [
                BlocProvider.value(value: NavigationBloc()),
                BlocProvider.value(value: SignupBloc()),
                BlocProvider.value(value: LoginBloc()),
                BlocProvider.value(value: ForgetPasswordBloc()),
                BlocProvider.value(value: UserBloc()),
                BlocProvider.value(value: TaskBloc()),
                BlocProvider.value(value: ProjectBloc())
              ],
              child: MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: MaterialApp(
                    navigatorKey: navigatorKey,
                    localizationsDelegates: const [
                      AppLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: L10n.all,
                    locale: _locale,
                    navigatorObservers: <NavigatorObserver>[observer],
                    debugShowCheckedModeBanner: false,
                    theme: ThemeData(
                      appBarTheme: const AppBarTheme(
                        backgroundColor: white,
                        surfaceTintColor: white,
                      ),
                      fontFamily: 'Poppins',
                      cupertinoOverrideTheme: const CupertinoThemeData(
                        primaryColor: black,
                      ),
                      textSelectionTheme:
                          const TextSelectionThemeData(cursorColor: black),
                      inputDecorationTheme: InputDecorationTheme(
                        border: OutlineInputBorder(
                          borderRadius: borderRadius(),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: borderRadius(),
                          borderSide:
                              const BorderSide(color: transparent, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: borderRadius(),
                          borderSide: const BorderSide(color: transparent),
                        ),
                        errorStyle:
                            const TextStyle(color: redTextColor, fontSize: 15),
                      ),
                    ),
                    initialRoute: PageName.splashScreen,
                    onGenerateRoute: AppRouter().onGenerateRoute,
                  )));
        });
  }
}
