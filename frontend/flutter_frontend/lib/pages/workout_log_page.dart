// lib/pages/workout_log_page.dart
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:fixnum/fixnum.dart' as fixnum;

import '../proto/user.pbgrpc.dart';
import '../services/grpc_client.dart';
import '../constants/workout_categories.dart';
import '../widgets/edit_log_dialog.dart';
import 'login_page.dart';
import 'account_page.dart';

// Done and not done helpers
bool _isLogDone(WorkoutLogMessage log) {
  return log.content.trimLeft().startsWith('[x]');
}

String _contentWithoutDonePrefix(String content) {
  final trimmed = content.trimLeft();
  if (trimmed.startsWith('[x]')) {
    return trimmed.substring(3).trimLeft();
  }
  if (trimmed.startsWith('[ ]')) {
    return trimmed.substring(3).trimLeft();
  }
  return content;
}

String _toggleDoneInContent(String content) {
  final trimmed = content.trimLeft();
  if (trimmed.startsWith('[x]')) {
    return '[ ] ${_contentWithoutDonePrefix(content)}';
  }
  if (trimmed.startsWith('[ ]')) {
    return '[x] ${_contentWithoutDonePrefix(content)}';
  }
  return '[x] ${content.trimLeft()}';
}

enum LogSortMode {
  newestFirst,
  oldestFirst,
}

class WorkoutLogPage extends StatefulWidget {
  const WorkoutLogPage({
    super.key,
    required this.userId,
    required this.token,
    required this.email,
  });

  final int userId;
  final String token;
  final String email;

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

  String _selectedCategory = workoutCategories.last; // default is "Other"
  String _searchQuery = '';
  String _filterCategory = 'All';
  LogSortMode _sortMode = LogSortMode.newestFirst;

  String? _userName;
  String? _userEmailOverride;
  DateTime? _dob;

  @override
  void initState() {
    super.initState();
    _channel = createChannel();
    _stub = UserServiceClient(_channel);
    _userEmailOverride = widget.email;
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
          category: _selectedCategory,
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
    final contentText = _contentWithoutDonePrefix(log.content);
    final initialCategory =
        log.category.isEmpty ? workoutCategories.last : log.category;

    final updated = await showDialog<EditLogResult>(
      context: context,
      builder: (ctx) => EditLogDialog(
        initialContent: contentText,
        initialCategory: initialCategory,
      ),
    );

    if (updated == null || updated.content.trim().isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
      _status = '';
    });

    try {
      final newContent = _isLogDone(log)
          ? '[x] ${updated.content.trim()}'
          : updated.content.trim();

      final resp = await _stub.updateWorkoutLog(
        UpdateWorkoutLogRequest(
          id: log.id,
          userId: fixnum.Int64(widget.userId),
          content: newContent,
          category: updated.category,
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

  Future<void> _toggleDone(WorkoutLogMessage log) async {
    setState(() {
      _isLoading = true;
      _status = '';
    });

    try {
      final newContent = _toggleDoneInContent(log.content);

      final resp = await _stub.updateWorkoutLog(
        UpdateWorkoutLogRequest(
          id: log.id,
          userId: fixnum.Int64(widget.userId),
          content: newContent,
          category: log.category,
        ),
      );

      setState(() {
        _logs = _logs
            .map((l) => l.id == log.id ? resp.log : l)
            .toList(growable: false);
      });
    } catch (e) {
      setState(() {
        _status = 'Failed to toggle log: $e';
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

  Future<void> _openAccountPage() async {
    final result = await Navigator.of(context).push<AccountPageResult>(
      MaterialPageRoute(
        builder: (_) => AccountPage(
          userId: widget.userId,
          token: widget.token,
          initialName: _userName ?? '',
          initialEmail: _userEmailOverride ?? widget.email,
          initialDob: _dob,
        ),
      ),
    );

    if (result == null) return;

    if (result.deactivated) {
      _logout();
      return;
    }

    setState(() {
      final trimmedName = result.name?.trim() ?? '';
      _userName = trimmedName.isEmpty ? null : trimmedName;
      _userEmailOverride = result.email ?? _userEmailOverride;
      _dob = result.dob;
    });
  }

  // ---------- Date-aware search + sort. Allows user to search using 2025, 2025-11, or 2025-11-22 ----------

  bool _matchesDateQuery(WorkoutLogMessage log, String rawQuery) {
    if (rawQuery.isEmpty) return true;

    final created = DateTime.fromMillisecondsSinceEpoch(
      log.createdAtUnix.toInt() * 1000,
    );

    // Year: 2025
    if (RegExp(r'^\d{4}$').hasMatch(rawQuery)) {
      return created.year.toString() == rawQuery;
    }

    // Year-month: 2025-11
    if (RegExp(r'^\d{4}-\d{2}$').hasMatch(rawQuery)) {
      final ym =
          '${created.year.toString().padLeft(4, '0')}-${created.month.toString().padLeft(2, '0')}';
      return ym == rawQuery;
    }

    // Full date: 2025-11-01
    if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(rawQuery)) {
      final ymd =
          '${created.year.toString().padLeft(4, '0')}-${created.month.toString().padLeft(2, '0')}-${created.day.toString().padLeft(2, '0')}';
      return ymd == rawQuery;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // derive filtered + sorted logs
    final rawQuery = _searchQuery.trim();
    final lowerQuery = rawQuery.toLowerCase();

    List<WorkoutLogMessage> filtered = _logs.where((log) {
      final contentText =
          _contentWithoutDonePrefix(log.content).toLowerCase();
      final matchesText =
          lowerQuery.isEmpty || contentText.contains(lowerQuery);

      final matchesDate = _matchesDateQuery(log, rawQuery);

      final cat = log.category.isEmpty ? workoutCategories.last : log.category;
      final matchesCategory =
          _filterCategory == 'All' || cat == _filterCategory;

      // if query is empty: accept all; otherwise accept if either text OR date matches
      final matchesQuery =
          lowerQuery.isEmpty ? true : (matchesText || matchesDate);

      return matchesQuery && matchesCategory;
    }).toList();

    filtered.sort((a, b) {
      switch (_sortMode) {
        case LogSortMode.newestFirst:
          return b.createdAtUnix.compareTo(a.createdAtUnix);
        case LogSortMode.oldestFirst:
          return a.createdAtUnix.compareTo(b.createdAtUnix);
      }
    });

    final titleText = (_userName == null || _userName!.isEmpty)
        ? 'Workout Logger'
        : 'Welcome ${_userName!}';

    return Scaffold(
      appBar: AppBar(
        title: Text(titleText),
        actions: [
          IconButton(
            onPressed: _openAccountPage,
            icon: const Icon(Icons.account_circle),
            tooltip: 'Account',
          ),
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Column(
        children: [
          // input row
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
                DropdownButton<String>(
                  value: _selectedCategory,
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  items: workoutCategories
                      .map(
                        (c) => DropdownMenuItem(
                          value: c,
                          child: Text(c),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _isLoading ? null : _addLog,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          // search / filter / sort
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText:
                              'Search logs or type date (YYYY, YYYY-MM, YYYY-MM-DD)',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    DropdownButton<String>(
                      value: _filterCategory,
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _filterCategory = value;
                        });
                      },
                      items: [
                        const DropdownMenuItem(
                          value: 'All',
                          child: Text('All'),
                        ),
                        ...workoutCategories.map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Text(c),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    DropdownButton<LogSortMode>(
                      value: _sortMode,
                      onChanged: (mode) {
                        if (mode == null) return;
                        setState(() {
                          _sortMode = mode;
                        });
                      },
                      items: const [
                        DropdownMenuItem(
                          value: LogSortMode.newestFirst,
                          child: Text('Newest first'),
                        ),
                        DropdownMenuItem(
                          value: LogSortMode.oldestFirst,
                          child: Text('Oldest first'),
                        ),
                      ],
                    ),
                  ],
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
            child: filtered.isEmpty
                ? const Center(
                    child: Text('No workout logs yet. Add your first one.'),
                  )
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final log = filtered[index];
                      final isDone = _isLogDone(log);
                      final displayContent =
                          _contentWithoutDonePrefix(log.content);

                      final category =
                          log.category.isEmpty
                              ? workoutCategories.last
                              : log.category;

                      final created = DateTime.fromMillisecondsSinceEpoch(
                        log.createdAtUnix.toInt() * 1000,
                      );
                      final createdText =
                          '${created.year}-${created.month.toString().padLeft(2, '0')}-${created.day.toString().padLeft(2, '0')}';

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          onTap: () => _toggleDone(log),
                          leading: Icon(
                            isDone
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                          ),
                          title: Text(
                            displayContent,
                            style: TextStyle(
                              decoration: isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          subtitle: Text(
                            '$category · $createdText',
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