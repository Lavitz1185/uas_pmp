import 'package:flutter/material.dart';
import 'package:project_akhir_pmp/screens/opening/signin_screen.dart';
import 'package:project_akhir_pmp/screens/opening/signup_screen.dart';
import 'package:project_akhir_pmp/theme/theme.dart';
import 'package:project_akhir_pmp/widgets/custom_scaffold.dart';
import 'package:project_akhir_pmp/widgets/welcome_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
              flex: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 40.0,
                ),
                child: Center(
                    child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(children: [
                    TextSpan(
                        text: 'Get Started!\n',
                        style: TextStyle(
                            fontSize: 45.0,
                            fontWeight: FontWeight.w900,
                            color: Color.fromARGB(255, 254, 244, 255))),
                    TextSpan(
                        text:
                            'Jadikan Harimu Lebih Teratur dan Produktif Bersama Kami!',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ]),
                )),
              )),
          Flexible(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Row(children: [
                  const Expanded(
                    child: WelcomeButton(
                      buttonText: 'Login',
                      onTap: SigninScreen(),
                      color: Colors.transparent,
                      textColor: Colors.black54,
                    ),
                  ),
                  Expanded(
                    child: WelcomeButton(
                      buttonText: 'Sign up',
                      onTap: const SignUpScreen(),
                      color: Color.fromARGB(204, 255, 255, 255),
                      textColor: lightColorScheme.primary,
                    ),
                  ),
                ]),
              ))
        ],
      ),
    );
  }
}
