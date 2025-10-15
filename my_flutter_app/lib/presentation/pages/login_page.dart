import 'package:flutter/material.dart';
import 'package:my_flutter_app/presentation/widgets/custom_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background, // ignore: deprecated_member_use
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 32),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    'assets/images/pitty_logo.jpg',
                    width: 220,
                    height: 220,
                    fit: BoxFit.cover,
                    semanticLabel: 'Logo de Pitty Pâtisserie',
                  ),
                ),
                const SizedBox(height: 56),
                SizedBox(
                  width: 220,
                  child: Semantics(
                    button: true,
                    label: 'Ingresar',
                    child: CustomButton(
                      label: 'Ingresar',
                      filled: false,
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
