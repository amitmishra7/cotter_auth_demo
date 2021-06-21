import 'package:cotter/cotter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

class CotterAuth extends StatefulWidget {
  @override
  _CotterAuthState createState() => _CotterAuthState();
}

class _CotterAuthState extends State<CotterAuth> {
  // final cotter = Cotter(apiKeyID: cotter_api_key_id);//your API key
  final String redirectURL = 'com.example.cotterauthdemo://auth_callback';

  final registerController = TextEditingController();

  Future<void> register(BuildContext ctxt) async {
    final progress = ProgressHUD.of(ctxt);

    try {
      progress!.show();
      final user = await cotter
          // .signUpWithDevice(identifier: registerController.text)
          .signUpWithEmailOTP(
              redirectURL: redirectURL, email: registerController.text)
          // .signUpWithPhoneOTP(redirectURL: redirectURL,channels: [PhoneChannel.SMS])

          .then((user) {
        progress.dismiss();

        showDialog(
            context: ctxt,
            builder: (_) => AlertDialog(
                  content: Text(user == null ? 'null' : user.clientUserID),
                ));
      });
    } catch (e) {
      progress!.dismiss();
      showDialog(
          context: ctxt,
          builder: (_) => AlertDialog(
                content: Text(e.toString()),
              ));
    }
  }

  Future<void> login(BuildContext ctxt) async {
    final progress = ProgressHUD.of(ctxt);
    try {
      progress!.show();
      var event = await cotter
          // .signInWithDevice(identifier: loginController.text, context: ctxt)
          .signInWithEmailOTP(
              redirectURL: redirectURL, email: registerController.text)
          //  .signInWithPhoneOTP(redirectURL: redirectURL)
          .then((event) {
        progress.dismiss();
        showDialog(
            context: ctxt,
            builder: (_) => AlertDialog(
                  content: Text(event.clientUserID),
                ));
      });
      print(event);
    } on Exception catch (e) {
      progress!.dismiss();
      showDialog(
          context: ctxt,
          builder: (_) => AlertDialog(
                content: Text(e.toString()),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Cotter'),
        ),
        body: ProgressHUD(
          child: Builder(builder: (context) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 300),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: registerController,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: () => register(context),
                        child: Text('Register'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: () => login(context),
                        child: Text('Login'),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ));
  }
}
