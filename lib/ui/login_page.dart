import 'package:flutter/material.dart';
import 'package:flutter_bio_metric/ui/home_page.dart';
import 'package:flutter_bio_metric/ui/registration_page.dart';
import 'package:local_auth/local_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } catch (e) {
      canCheckBiometrics = false;
      print(e);
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _loginWithBiometrics() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Authenticate with your fingerprint',
        options: AuthenticationOptions(biometricOnly: true),

      );
    } catch (e) {
      print(e);
    }

    if (authenticated) {
      // Authentication successful, navigate to home page.
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biometric Login App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Biometric login:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _canCheckBiometrics ? _loginWithBiometrics : null,
              child: const Text('Login with Biometrics'),
            ),
            const SizedBox(height: 20),
            // const Text(
            //   'Don\'t have biometrics set up?',
            //   style: TextStyle(fontSize: 16),
            // ),
            // ElevatedButton(
            //   onPressed: () {
            //     // Navigate to a registration page to set up biometrics.
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => RegistrationPage()),
            //     );
            //   },
            //   child: const Text('Register Biometrics'),
            // ),
          ],
        ),
      ),
    );
  }
}
