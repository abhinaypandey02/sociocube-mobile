import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sociocube'),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final accessToken = ref.watch(accessTokenProvider);
          final refreshToken = ref.watch(refreshTokenProvider);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Token Status',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                
                // Access Token Status
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              accessToken != null ? Icons.check_circle : Icons.cancel,
                              color: accessToken != null ? Colors.green : Colors.red,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Access Token',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          accessToken != null ? 'Present' : 'Not set',
                          style: TextStyle(
                            color: accessToken != null ? Colors.green : Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (accessToken != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Token: ${accessToken.substring(0, 10)}...',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Refresh Token Status
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              refreshToken != null ? Icons.check_circle : Icons.cancel,
                              color: refreshToken != null ? Colors.green : Colors.red,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Refresh Token',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          refreshToken != null ? 'Present' : 'Not set',
                          style: TextStyle(
                            color: refreshToken != null ? Colors.green : Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (refreshToken != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Token: ${refreshToken.substring(0, 10)}...',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Test Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          ref.read(accessTokenProvider.notifier).setToken('test_access_token_12345');
                        },
                        child: const Text('Set Test Access Token'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          ref.read(accessTokenProvider.notifier).clearToken();
                        },
                        child: const Text('Clear Access Token'),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await ref.read(refreshTokenProvider.notifier).setToken('test_refresh_token_67890');
                        },
                        child: const Text('Set Test Refresh Token'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await ref.read(refreshTokenProvider.notifier).clearToken();
                        },
                        child: const Text('Clear Refresh Token'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 