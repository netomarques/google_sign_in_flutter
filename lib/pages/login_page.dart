import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in_flutter/providers/providers.dart';

class LoginPage extends ConsumerWidget {
  static LoginPage builder(BuildContext context, GoRouterState state) =>
      const LoginPage();

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () async {
            await ref.read(loginProvider.future);
          },
          icon: const FaIcon(FontAwesomeIcons.google),
          label: const Text('Login with Google'),
        ),
      ),
    );
  }
}
