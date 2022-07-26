import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:notary/controllers/authentication.dart';
import 'package:notary/controllers/user.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/utils/navigate.dart';
import 'package:notary/views/auth.dart';
import 'package:notary/widgets/modals/modal_container.dart';
import 'package:provider/provider.dart';

import 'button_primary_outline.dart';

class DeleteUser extends StatefulWidget {
  @override
  _DeleteUserState createState() => _DeleteUserState();
}

class _DeleteUserState extends State<DeleteUser> {
  AuthenticationController _authenticationController;
  UserController _userController;

  initState() {
    _authenticationController =
        Provider.of<AuthenticationController>(context, listen: false);
    _userController = Provider.of<UserController>(context, listen: false);
    super.initState();
  }

  _deleteUser() async {
    try {
      await _userController.deleteAccount();
      await _authenticationController.logOut();
      StateM(context).navOff(Auth());
      modalContainerSimple(
          Container(
            height: StateM(context).height() / 4 * 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: reSize(context, 80),
                    height: reSize(context, 80),
                    decoration: BoxDecoration(
                        color: Color(0xFFFC563D),
                        borderRadius: BorderRadius.circular(80)),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/images/26.svg',
                        width: reSize(context, 50),
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                  SizedBox(height: reSize(context, 20)),
                  Text(
                    'Done',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: reSize(context, 20)),
                  Text(
                    "We hope you will come back! For now your account will be permanently deleted.",
                    style: TextStyle(
                      color: Color(0xFF494949),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: reSize(context, 20)),
                  Text(
                    "If you need more details write me by email:",
                    style: TextStyle(
                      color: Color(0xFF494949),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: reSize(context, 20)),
                  Text(
                    "help@ronary.com",
                    style: TextStyle(
                      color: Color(0xFF494949),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          context);
    } catch (err) {
      showError(err, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: StateM(context).height() / 4 * 3,
        width: StateM(context).width(),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: reSize(context, 80),
                    height: reSize(context, 80),
                    decoration: BoxDecoration(
                        color: Color(0xFFFC563D),
                        borderRadius: BorderRadius.circular(80)),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/images/26.svg',
                        width: reSize(context, 50),
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                  SizedBox(height: reSize(context, 20)),
                  Text(
                    'Are you sure?',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: reSize(context, 20)),
                  Text(
                    "When you delete your account, your profile, documents, eJournal Log and video-audio recordings will be permanently removed.",
                    style: TextStyle(
                      color: Color(0xFF494949),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: reSize(context, 20)),
                  Text(
                    "You will be able to download your account content within 10 days after requesting deletion.",
                    style: TextStyle(
                      color: Color(0xFF494949),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 50),
                  ButtonPrimaryOutline(
                    width: reSize(context, 230),
                    text: 'Delete',
                    callback: _deleteUser,
                    color: Colors.red,
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
