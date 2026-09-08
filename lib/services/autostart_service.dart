import 'dart:io';

/// Manages autostart-on-login by writing/removing a standard
/// XDG autostart .desktop file at ~/.config/autostart/.
/// This is the Linux-native mechanism most desktop environments
/// (GNOME, KDE, XFCE) respect out of the box.
class AutostartService {
  static const String _desktopFileName = 'fileflow_desktop.desktop';

  static String get _autostartDir =>
      '${Platform.environment['HOME']}/.config/autostart';

  static String get _desktopFilePath => '$_autostartDir/$_desktopFileName';

  static Future<bool> isEnabled() async {
    return File(_desktopFilePath).exists();
  }

  static Future<void> enable() async {
    final dir = Directory(_autostartDir);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    final exePath = Platform.resolvedExecutable;

    final desktopFileContent = '''
[Desktop Entry]
Type=Application
Name=FileFlow
Exec=$exePath
Icon=fileflow
Comment=FileFlow background upload utility
X-GNOME-Autostart-enabled=true
Terminal=false
''';

    await File(_desktopFilePath).writeAsString(desktopFileContent);
  }

  static Future<void> disable() async {
    final file = File(_desktopFilePath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
