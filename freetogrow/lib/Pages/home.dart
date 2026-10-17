import 'package:flutter/material.dart';
import 'package:freetogrow/Controllers/create_user_controller.dart';
import 'package:freetogrow/Repositories/players_repo.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:freetogrow/Widgets/grid_square.dart';

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
    _createUserController = CreateUserController(PlayersRepo());
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  Future<String?> _createUser() async {
    setState(() {
      _createUserController.isLoading = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SizedBox(
            height: 200,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircularProgressIndicator(),
                    Text(
                      'Looking for a game...',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    try {
      final String? id = await _createUserController.createUser(
        username: usernameController.text,
      );

      if (!mounted) return id;

      Navigator.of(context).pop(); // Close loading dialog

      setState(() {
        _createUserController.isLoading = false;
      });

      if (_createUserController.error != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_createUserController.error!)));
      }

      return id;
    } finally {
      if (mounted && _createUserController.isLoading) {
        Navigator.of(context).pop();
        setState(() {
          _createUserController.isLoading = false;
        });
      }
    }
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
