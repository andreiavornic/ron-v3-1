import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/utils/navigate.dart';
import 'package:notary/views/auth.dart';

import 'button_primary_outline.dart';

class ConfirmPasswordReset extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: reSize(context, 96),
                      height: reSize(context, 96),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/images/120.svg',
                          width: reSize(context, 35),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: reSize(context, 20),
                    ),
                    Text(
                      'Done!',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF000000),
                        // letterSpacing: -1.5,
                      ),
                    ),
                    SizedBox(
                      height: reSize(context, 20),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 40, right: 40),
                      child: Text(
                        'Your password has been updated',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF414141),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: reSize(context, 45),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        child: ButtonPrimaryOutline(
                          callback: () => StateM(context).navOff(Auth()),
                          text: 'Login',
                          width: reSize(context, 232),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
