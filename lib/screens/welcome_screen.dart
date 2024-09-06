import 'package:flutter/material.dart';
import 'dart:async';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _logoAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _textAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    // Naviguer vers l'écran de connexion après un délai
    Timer(Duration(seconds: 6), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple, // Fond coloré
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo animé avec effet élastique
                  ScaleTransition(
                    scale: _logoAnimation,
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset(
                          'assets/images/logo2.png',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  // Texte de bienvenue avec animation douce
                  FadeTransition(
                    opacity: _textAnimation,
                    child: Text(
                      'Bienvenue sur GestTicket',
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Message d'encouragement avec un style plus léger et espacement ajusté
                  FadeTransition(
                    opacity: _textAnimation,
                    child: Text(
                      'Obtenez de l\'aide rapidement et efficacement grâce à GestTicket. Soumettez vos tickets et recevez des réponses rapides de vos formateurs pour faciliter votre apprentissage.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        fontWeight: FontWeight.w400,
                        height: 1.6, // l'espacement des lignes
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
