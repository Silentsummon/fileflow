import 'package:flutter/material.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _urlController = TextEditingController();
  final _apiKeyController = TextEditingController();
  bool _loading = true;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentValues();
  }

  Future<void> _loadCurrentValues() async {
    final url = await SettingsService.getBackendUrl();
    final apiKey = await SettingsService.getApiKey();
    setState(() {
      _urlController.text = url;
      _apiKeyController.text = apiKey;
      _loading = false;
    });
  }

  Future<void> _save() async {
    await SettingsService.setBackendUrl(_urlController.text.trim());
    await SettingsService.setApiKey(_apiKeyController.text.trim());
    setState(() => _saved = true);
  }

  @override
  void dispose() {
    _urlController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _urlController,
                    decoration: const InputDecoration(
                      labelText: 'Backend URL',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() => _saved = false),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _apiKeyController,
                    decoration: const InputDecoration(
                      labelText: 'API Key',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    onChanged: (_) => setState(() => _saved = false),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _save,
                    child: const Text('Save'),
                  ),
                  if (_saved) ...[
                    const SizedBox(height: 12),
                    const Text(
                      'Saved. Takes effect on next upload.',
                      style: TextStyle(color: Colors.green),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
