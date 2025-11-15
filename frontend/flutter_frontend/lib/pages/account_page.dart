// lib/pages/account_page.dart
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:fixnum/fixnum.dart' as fixnum;

import '../proto/user.pbgrpc.dart';
import '../services/grpc_client.dart';

class AccountPageResult {
  AccountPageResult({
    this.name,
    this.email,
    this.dob,
    this.deactivated = false,
  });

  final String? name;
  final String? email;
  final DateTime? dob;
  final bool deactivated;
}

class AccountPage extends StatefulWidget {
  const AccountPage({
    super.key,
    required this.userId,
    required this.token,
    required this.initialName,
    required this.initialEmail,
    this.initialDob,
  });

  final int userId;
  final String token;
  final String initialName;
  final String initialEmail;
  final DateTime? initialDob;

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  DateTime? _dob;

  late ClientChannel _channel;
  late UserServiceClient _stub;

  bool _isLoading = false;
  String _status = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _emailController = TextEditingController(text: widget.initialEmail);
    _dob = widget.initialDob;

    _channel = createChannel();
    _stub = UserServiceClient(_channel);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _channel.shutdown();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final initialDate = _dob ??
        DateTime(now.year - 20, now.month, now.day); // default 20 years ago

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900, 1, 1),
      lastDate: now,
    );

    if (picked != null) {
      setState(() {
        _dob = picked;
      });
    }
  }

  void _save() {
    Navigator.of(context).pop(
      AccountPageResult(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        dob: _dob,
      ),
    );
  }

  Future<void> _deactivate() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Deactivate account'),
        content: const Text(
          'Are you sure you want to deactivate your account?\n'
          'You will not be able to log in again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      _isLoading = true;
      _status = '';
    });

    try {
      await _stub.deactivateAccount(
        DeactivateAccountRequest(
          userId: fixnum.Int64(widget.userId),
        ),
      );

      Navigator.of(context).pop(
        AccountPageResult(
          deactivated: true,
        ),
      );
    } catch (e) {
      setState(() {
        _status = 'Failed to deactivate: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final dobText = _dob == null
        ? 'Select date of birth'
        : '${_dob!.year}-${_dob!.month.toString().padLeft(2, '0')}-${_dob!.day.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _pickDob,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date of birth',
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(dobText),
                        const Icon(Icons.calendar_today, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _save,
                        child: const Text('Save'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading ? null : _deactivate,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Deactivate account'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_status.isNotEmpty)
                  Text(
                    _status,
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
          if (_isLoading)
            const LinearProgressIndicator(
              minHeight: 2,
            ),
        ],
      ),
    );
  }
}