import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fixnum/fixnum.dart' as fixnum;
import 'package:grpc/grpc.dart';
import 'proto/user.pbgrpc.dart';


void main() {
  runApp(const MyApp());
}

String backendHost() {
  // You can refine this if you run on real devices later
  return 'localhost';
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Logger',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late ClientChannel _channel;
  late UserServiceClient _stub;

  String _status = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _channel = ClientChannel(
      backendHost(),
      port: 50051,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );

    _stub = UserServiceClient(_channel);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _channel.shutdown();
    super.dispose();
  }

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _status = '';
    });

    try {
      final resp = await _stub.register(
        RegisterRequest(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
      setState(() {
        _status = 'Registered: ${resp.email} (id: ${resp.id})';
      });
    } catch (e) {
      setState(() {
        _status = 'Register failed: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _status = '';
    });

    try {
      final resp = await _stub.login(
        LoginRequest(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );

      // Navigate to workout log screen on success
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => WorkoutLogPage(
            userId: resp.id.toInt(),
            token: resp.token,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _status = 'Login failed: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Welcome to Workout Logger',
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        child: const Text('Login'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading ? null : _register,
                        child: const Text('Register'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_isLoading) const CircularProgressIndicator(),
                if (_status.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    _status,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WorkoutLogPage extends StatefulWidget {
  const WorkoutLogPage({
    super.key,
    required this.userId,
    required this.token,
  });

  final int userId;
  final String token;

  @override
  State<WorkoutLogPage> createState() => _WorkoutLogPageState();
}

class _WorkoutLogPageState extends State<WorkoutLogPage> {
  final TextEditingController _logController = TextEditingController();

  late ClientChannel _channel;
  late UserServiceClient _stub;

  List<WorkoutLogMessage> _logs = [];
  bool _isLoading = false;
  String _status = '';

  @override
  void initState() {
    super.initState();

    _channel = ClientChannel(
      backendHost(),
      port: 50051,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );

    _stub = UserServiceClient(_channel);

    _loadLogs();
  }

  @override
  void dispose() {
    _logController.dispose();
    _channel.shutdown();
    super.dispose();
  }

  Future<void> _loadLogs() async {
    setState(() {
      _isLoading = true;
      _status = '';
    });

    try {
      final resp = await _stub.listWorkoutLogs(
        ListWorkoutLogsRequest(userId: fixnum.Int64(widget.userId)),
      );

      setState(() {
        _logs = resp.logs;
      });
    } catch (e) {
      setState(() {
        _status = 'Failed to load logs: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addLog() async {
    final text = _logController.text.trim();
    if (text.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
      _status = '';
    });

    try {
      final resp = await _stub.createWorkoutLog(
        CreateWorkoutLogRequest(
          userId: fixnum.Int64(widget.userId),
          content: text,
        ),
      );

      setState(() {
        _logs = [resp.log, ..._logs];
        _logController.clear();
      });
    } catch (e) {
      setState(() {
        _status = 'Failed to add log: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _editLog(WorkoutLogMessage log) async {
    final controller = TextEditingController(text: log.content);

    final updated = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit log'),
        content: TextField(
          controller: controller,
          maxLines: null,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (updated == null || updated.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
      _status = '';
    });

    try {
      final resp = await _stub.updateWorkoutLog(
        UpdateWorkoutLogRequest(
          id: log.id,
          userId: fixnum.Int64(widget.userId),
          content: updated,
        ),
      );

      setState(() {
        _logs = _logs
            .map((l) => l.id == log.id ? resp.log : l)
            .toList(growable: false);
      });
    } catch (e) {
      setState(() {
        _status = 'Failed to update log: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteLog(WorkoutLogMessage log) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete log'),
        content: const Text('Are you sure you want to delete this log?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) {
      return;
    }

    setState(() {
      _isLoading = true;
      _status = '';
    });

    try {
      await _stub.deleteWorkoutLog(
        DeleteWorkoutLogRequest(
          id: log.id,
          userId: fixnum.Int64(widget.userId),
        ),
      );

      setState(() {
        _logs = _logs.where((l) => l.id != log.id).toList(growable: false);
      });
    } catch (e) {
      setState(() {
        _status = 'Failed to delete log: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Logger'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _logController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      labelText: 'Workout log (sets, reps, notes)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _isLoading ? null : _addLog,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          if (_isLoading) const LinearProgressIndicator(),
          if (_status.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                _status,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          Expanded(
            child: _logs.isEmpty
                ? const Center(
                    child: Text('No workout logs yet. Add your first one.'),
                  )
                : ListView.builder(
                    itemCount: _logs.length,
                    itemBuilder: (context, index) {
                      final log = _logs[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          title: Text(log.content),
                          subtitle: Text(
                            'Log #${_logs.length - index}',
                            style: theme.textTheme.bodySmall,
                          ),
                          trailing: Wrap(
                            spacing: 8,
                            children: [
                              IconButton(
                                onPressed: () => _editLog(log),
                                icon: const Icon(Icons.edit),
                                tooltip: 'Edit',
                              ),
                              IconButton(
                                onPressed: () => _deleteLog(log),
                                icon: const Icon(Icons.delete),
                                tooltip: 'Delete',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}