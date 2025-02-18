import 'package:expense_management/screens/display_expenses.dart';
import 'package:expense_management/screens/login_screen.dart';
import 'package:expense_management/providers/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);

  initializeLocalNotifications();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      showLocalNotification(message);
    }

  });


  runApp(const ProviderScope(child: MyApp()));
}


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void initializeLocalNotifications() {
  const AndroidInitializationSettings androidInitializationSettings =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
  );
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

void showLocalNotification(RemoteMessage message) {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'expenses_channel',
    'Expense Notifications',
    importance: Importance.high,
    priority: Priority.high,
  );
  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidDetails,
  );

  flutterLocalNotificationsPlugin.show(
    0,
    message.notification?.title,
    message.notification?.body,
    notificationDetails,
  );
}



Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('Background message received: ${message.notification?.title}');
  }
}
FirebaseMessaging messaging = FirebaseMessaging.instance;

void requestPermission() async {
  NotificationSettings settings = await messaging.requestPermission();
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    if (kDebugMode) {
      print("Permission granted");
    }
  } else {
    if (kDebugMode) {
      print("Permission denied");
    }
  }
}

class MyApp extends ConsumerStatefulWidget  {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  var userId = StateProvider((ref) => '',);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      if(FirebaseAuth.instance.currentUser != null){
        ref.read(userId.notifier).state = FirebaseAuth.instance.currentUser!.uid;
      } else{
        ref.read(userId.notifier).state = '0';
      }
    },);
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final user = ref.watch(userId);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeMode,
      home: user == '' ? Image.asset('assets/images/appIcon.png') : user == '0' ?  const LoginScreen() : ExpensesScreen(),
    );
  }
}
