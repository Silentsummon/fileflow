import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'state/upload_queue.dart';
import 'screens/home_screen.dart';
import 'services/tray_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await windowManager.setPreventClose(true);

  await TrayService().init();

  runApp(
    ChangeNotifierProvider(
      create: (_) => UploadQueue(),
      child: const FileFlowApp(),
    ),
  );
}

class FileFlowApp extends StatefulWidget {
  const FileFlowApp({super.key});

  @override
  State<FileFlowApp> createState() => _FileFlowAppState();
}

class _FileFlowAppState extends State<FileFlowApp> with WindowListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowClose() async {
    await windowManager.hide();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FileFlow',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const HomeScreen(),
    );
  }
}
