import 'dart:io';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';
import 'package:path/path.dart' as p;
import 'autostart_service.dart';

class TrayService with TrayListener {
  static final TrayService _instance = TrayService._internal();
  factory TrayService() => _instance;
  TrayService._internal();

  Future<void> init() async {
    trayManager.addListener(this);

    final exeDir = p.dirname(Platform.resolvedExecutable);
    final iconPath = p.join(exeDir, 'data', 'flutter_assets', 'assets', 'tray_icon_v2.png');
    await trayManager.setIcon(iconPath);

    await _refreshMenu();
  }

  Future<void> _refreshMenu() async {
    final autostartEnabled = await AutostartService.isEnabled();

    final menu = Menu(
      items: [
        MenuItem(key: 'show', label: 'Open FileFlow'),
        MenuItem.separator(),
        MenuItem.checkbox(
          key: 'toggle_autostart',
          label: 'Launch on login',
          checked: autostartEnabled,
        ),
        MenuItem.separator(),
        MenuItem(key: 'quit', label: 'Quit'),
      ],
    );
    await trayManager.setContextMenu(menu);
  }

  @override
  void onTrayIconMouseDown() {
    _toggleWindow();
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) async {
    switch (menuItem.key) {
      case 'show':
        await windowManager.show();
        await windowManager.focus();
        break;
      case 'toggle_autostart':
        final currentlyEnabled = await AutostartService.isEnabled();
        if (currentlyEnabled) {
          await AutostartService.disable();
        } else {
          await AutostartService.enable();
        }
        await _refreshMenu();
        break;
      case 'quit':
        await windowManager.destroy();
        break;
    }
  }

  Future<void> _toggleWindow() async {
    final isVisible = await windowManager.isVisible();
    if (isVisible) {
      await windowManager.hide();
    } else {
      await windowManager.show();
      await windowManager.focus();
    }
  }
}
