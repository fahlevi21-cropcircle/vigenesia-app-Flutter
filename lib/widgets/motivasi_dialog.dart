import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vigenesia/models/motivasi/motivasi_model.dart';
import 'package:flutter_gravatar/flutter_gravatar.dart';
import 'package:flutter_gravatar/utils.dart';
import 'package:http/http.dart' as http;
import 'package:vigenesia/util/user_preferences.dart';

class MotivasiDialog extends StatefulWidget {
  final MotivasiModel motivasi;
  bool belongsToUser;
  MotivasiDialog({Key? key, required this.motivasi, this.belongsToUser = false})
      : super(key: key);

  @override
  _MotivasiDialogState createState() => _MotivasiDialogState();
}

class _MotivasiDialogState extends State<MotivasiDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    final avatar = Gravatar(widget.motivasi.user!.email!);
    return Stack(
      children: <Widget>[
        Container(
          padding:
              EdgeInsets.only(left: 20, top: 45 + 20, right: 20, bottom: 20),
          margin: EdgeInsets.only(top: 45),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            /* boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ] */
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.motivasi.user!.name!,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                widget.motivasi.isi!,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  widget.belongsToUser
                      ? ElevatedButton(
                          onPressed: () {
                            // Respond to button press
                            Navigator.of(context)
                                .pushNamed('/form', arguments: widget.motivasi);
                          },
                          child: Text('UPDATE'),
                        )
                      : SizedBox(),
                  SizedBox(
                    width: 8.0,
                  ),
                  widget.belongsToUser
                      ? ElevatedButton(
                          onPressed: () {
                            // Respond to button press
                            delete(widget.motivasi).then((value) => null);
                          },
                          child: Text('DELETE'),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red)),
                        )
                      : SizedBox(),
                  SizedBox(
                    width: 8.0,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      // Respond to button press
                      Navigator.pop(context);
                    },
                    child: Text("CLOSE"),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                ],
              )
            ],
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 45,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(45)),
              child: Image.network(avatar.imageUrl()),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> delete(MotivasiModel model) async {
    final _user = await UserPreferences().loadUser();
    try {
      var res = await http.delete(
        Uri.parse('http://192.168.43.21:8000/api/motivasi/${model.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${_user.token}',
        },
      );

      if (res.statusCode == 200) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (route) => false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Success')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('An error occured!')));
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
