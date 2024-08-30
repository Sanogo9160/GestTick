import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _logoAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _textAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _buttonAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fond blanc pour l'écran
          Container(
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo animé
                  ScaleTransition(
                    scale: _logoAnimation,
                    child: Image.asset(
                      'assets/images/logo2.png',
                      height: 100,
                    ),
                  ),
                  SizedBox(height: 40),
                  // Texte de bienvenue animé
                  FadeTransition(
                    opacity: _textAnimation,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Bienvenue sur GestTicket',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Commentaire d'encouragement animé
                  FadeTransition(
                    opacity: _textAnimation,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Avec GestTicket, bénéficiez d\'une aide rapide et personnalisée pour vos questions ou problèmes liés à la formation. Soumettez facilement vos tickets et obtenez des réponses efficaces de vos formateurs. Nous sommes là pour vous soutenir à chaque étape de votre apprentissage!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.normal,
                          height: 1.5, // Espacement entre les lignes
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  // Bouton animé
                  ScaleTransition(
                    scale: _buttonAnimation,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.deepPurple, // Couleur du texte du bouton
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5, // Ombrage pour le bouton
                      ),
                      child: Text(
                        'Commencer',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
