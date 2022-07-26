import 'dart:io';

import 'package:path/path.dart' as Path;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:notary/controllers/session.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/utils/navigate.dart';
import 'package:notary/views/scan_image.dart';
import 'package:notary/widgets/loading.dart';
import 'package:notary/widgets/modals/modal_container.dart';
import 'package:provider/provider.dart';

import '../document-setting.dart';

class StartSession extends StatefulWidget {
  const StartSession({Key key}) : super(key: key);

  @override
  _StartSessionState createState() => _StartSessionState();
}

class _StartSessionState extends State<StartSession> {
  bool _loading;

  @override
  void initState() {
    _loading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Loading()
        : Column(
            children: [
              Container(
                width: reSize(context, 80),
                height: reSize(context, 80),
                child: TextButton(
                  onPressed: () => _createSession(context),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.secondary,
                    ),
                    overlayColor: MaterialStateProperty.all(
                      Color(0xFF000000).withOpacity(0.1),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(150),
                      ),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      size: reSize(context, 45),
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Text(
                "New Session",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              )
            ],
          );
  }

  _createSession(context) async {
    modalContainerSimple(
        Container(
          decoration: BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 50,
              left: 30,
              right: 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: StateM(context).width() - 40,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Upload documents",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -1,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: reSize(context, 5)),
                      Text(
                        "Select documents",
                        style: TextStyle(
                          color: Color(0xFF20303C),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: reSize(context, 40)),
                TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                    ),
                    overlayColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                    ),
                  ),
                  onPressed: () => _importFilePhone(context),
                  child: Row(
                    children: [
                      SvgPicture.asset("assets/images/55.svg"),
                      SizedBox(
                        width: reSize(context, 20),
                      ),
                      Text(
                        "Import File",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
                Divider(
                  color: Color(0xFFE8EAF0),
                  height: reSize(context, 1),
                ),
                TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                    ),
                    overlayColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                    ),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => ScanImage(),
                      transitionDuration: Duration(seconds: 0),
                    ),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset("assets/images/56.svg"),
                      SizedBox(width: reSize(context, 20)),
                      Text(
                        "Scan Document",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
                Divider(
                  color: Color(0xFFE8EAF0),
                  height: 1,
                ),
                SizedBox(height: reSize(context, 25)),
                Container(
                  width: StateM(context).width() - 40,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Acceptable formats:',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'PDF - up to 15 Mb',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        context);
  }

  Future<void> _importFilePhone(ctx) async {
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        _loading = true;
        setState(() {});
        if (result.files.first.size > 15000000) {
          showError('The file must not contain more than 15 Mb', context);
          return;
        }

        File file = File(result.files.single.path);
        var extension = Path.extension(file.path);
        if (extension != '.pdf') {
          return;
        } else if (file.lengthSync() > (7.5e+7 * 75).toInt()) {
          return;
        }
        StateM(ctx).navBack();

        await Provider.of<SessionController>(ctx, listen: false)
            .createSession(file);
        _loading = false;
        setState(() {});

        StateM(ctx).navTo(DocumentSetting());
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => DocumentSetting(),
        //   ),
        // );
      }
    } catch (err) {
      _loading = false;
      // setState(() {});
      StateM(ctx).navBack();
      showError(err, ctx);
    }
  }
}
