import 'package:flutter/material.dart';
import 'package:freetogrow/Controllers/create_user_controller.dart';
import 'package:freetogrow/Repositories/game_state_repo.dart';
import 'package:freetogrow/Repositories/players_repo.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final usernameController = TextEditingController();
  late final CreateUserController _createUserController;

  @override
  void initState() {
    _createUserController = CreateUserController(
      PlayersRepo(),
      GameStateRepo(),
    );
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  Future<(String, String, String, String)?> _createUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Dialog(
        child: SizedBox(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('Looking for a game...'),
              ],
            ),
          ),
        ),
      ),
    );

    (String, String, String, String)? results;

    try {
      results = await _createUserController.createUser(
        username: usernameController.text,
      );
    } finally {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }

    if (results != null && mounted) {
      Navigator.pushNamed(
        context,
        '/grid',
        arguments: {
          'userId': results.$1,
          'username': results.$2,
          'opponentName': results.$3,
          'gameId': results.$4,
        },
      );
    }

    if (_createUserController.error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(_createUserController.error!)));
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 150),
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'free',
                      style: GoogleFonts.acme(
                        fontSize: 45,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    ),
                    TextSpan(
                      text: 'to',
                      style: GoogleFonts.acme(
                        fontSize: 45,
                        fontWeight: FontWeight.w500,
                        color: Colors.orange,
                      ),
                    ),
                    TextSpan(
                      text: 'grow',
                      style: GoogleFonts.acme(
                        fontSize: 45,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    Image.asset('assets/homepageplant.png'),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Player Name',
                          hintText: 'Enter your name',
                          floatingLabelStyle: TextStyle(color: Colors.green),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.green),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton(
                        onPressed: _createUser,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF7AD475),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Find game",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
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
