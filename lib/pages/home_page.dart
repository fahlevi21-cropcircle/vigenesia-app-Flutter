import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gravatar/flutter_gravatar.dart';
import 'package:vigenesia/models/user/user.dart';
import 'package:vigenesia/models/motivasi_response/motivasi_response.dart';
import 'package:http/http.dart' as http;
import 'package:vigenesia/util/user_preferences.dart';
import 'package:vigenesia/widgets/motivasi_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user;

  @override
  void initState() {
    UserPreferences().loadUser().then((value) => user = value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Vigenesia',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xff07E4F8),
        actions: [
          //list if widget in appbar actions
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Text(
                  "Logout",
                ),
              ),
            ],
            onSelected: (item) => {
              UserPreferences().logout().then((value) => {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Logged out'))),
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/login', (route) => false)
                  }),
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Respond to button press
          Navigator.of(context).pushNamed('/form');
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Container(
          child: FutureBuilder<MotivasiResponse>(
            future: fetchAll(),
            builder: (ctx, res) {
              if (res.hasData) {
                return motivasiList(res);
              } else if (res.hasError) {
                return Container(
                  child: Center(
                    child: Text(
                      res.error.toString(),
                    ),
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget motivasiList(AsyncSnapshot<MotivasiResponse> res) {
    return ListView.builder(
      itemCount: res.data!.data!.length,
      itemBuilder: (ctx, i) {
        return GestureDetector(
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(45)),
                    child: Image.network(
                        Gravatar(res.data!.data![i].user!.email!).imageUrl()),
                  ),
                  title: Text(res.data!.data![i].user!.name!),
                  subtitle: Text(
                    res.data!.data![i].user!.email!,
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    res.data!.data![i].isi!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w200,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            log(res.data!.data![i].toJson());
            showDialog(
              context: context,
              builder: (ctx) {
                return MotivasiDialog(
                  motivasi: res.data!.data![i],
                  belongsToUser: res.data!.data![i].user!.id == user!.id,
                );
              },
            );
          },
        );
      },
    );
  }

  Future<MotivasiResponse> fetchAll() async {
    final _user = await UserPreferences().loadUser();
    final response = await http.get(
      Uri.parse("http://192.168.43.21:8000/api/motivasi"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${_user.token}',
      },
    );

    if (response.statusCode == 200) {
      return MotivasiResponse.fromJson(response.body);
    } else {
      throw Exception('Network Error');
    }
  }
}
