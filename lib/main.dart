import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sehetna/fetures/appointments/manager/getComplanits/get_complaints_cubit.dart';
import 'package:sehetna/fetures/auth/manager/login/login_cubit.dart';
import 'package:sehetna/fetures/appointments/manager/appointmentDetails/appointment_details_cubit.dart';
import 'package:sehetna/fetures/appointments/manager/getRequests/get_requests_cubit.dart';
import 'package:sehetna/fetures/categories/manager/createService/create_service_cubit.dart';
import 'package:sehetna/fetures/categories/manager/getCategory/get_category_services_cubit.dart';
import 'package:sehetna/fetures/categories/manager/servicesList/services_list_cubit.dart';
import 'package:sehetna/fetures/home/manager/getAllCategories/get_all_categories_cubit.dart';
import 'package:sehetna/fetures/home/manager/getLocation/get_location_cubit.dart';
import 'package:sehetna/fetures/home/manager/ongoingRequests/ongoing_requests_cubit.dart';
import 'package:sehetna/fetures/profile/manager/language/change_language_cubit.dart';
import 'package:sehetna/fetures/profile/manager/services/email_luancher.dart';
import 'package:sehetna/fetures/splash/view/splash_view.dart';
import 'package:sehetna/firebase_options.dart';
import 'package:sehetna/generated/l10n.dart';
import 'package:sehetna/push_notification_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences pref;
bool get isLoggedIn => pref.getString('token')?.isNotEmpty ?? false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  pref = await SharedPreferences.getInstance();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await PushNotificationServices.init();

  final initialLanguage = pref.getString('language') ?? 'en';

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => LoginCubit()),
      BlocProvider(create: (context) => GetLocationCubit()),
      BlocProvider(create: (context) => AppointmentDetailsCubit()),
      BlocProvider(create: (context) => GetRequestsCubit()),
      BlocProvider(create: (context) => GetComplaintsCubit()),
      BlocProvider(create: (context) => GetCategoryServicesCubit()),
      BlocProvider(create: (context) => CreateServiceCubit()),
      BlocProvider(create: (context) => OngoingRequestsCubit()),
      BlocProvider(create: (context) => ServicesListCubit()),
      BlocProvider(create: (context) => GetAllCategoriesCubit()),
      BlocProvider(
        create: (context) => ChangeLanguageCubit()
          // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
          ..emit(
            ChangeLanguageInitial(initialLanguage),
          ),
      ),
    ],
    child: const SehetnaApp(),
  ));
}

class SehetnaApp extends StatelessWidget {
  const SehetnaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangeLanguageCubit, ChangeLanguageState>(
      builder: (context, state) {
        String languageCode;
        if (state is ChangeLanguageInitial) {
          languageCode = state.currentLanguage;
        } else if (state is ChangeLanguageSuccess) {
          languageCode = state.languageCode;
        } else {
          languageCode = pref.getString('language') ?? 'en';
        }

        return MaterialApp(
          navigatorKey: navigatorKey,
          locale: Locale(languageCode),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          theme: ThemeData(fontFamily: "inter"),
          home: const SplashView(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
