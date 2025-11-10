import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String textoBoton;

  RoundedButton(this.textoBoton, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Navegando...")),
        );
      },
      child: Container(
        height: 50,
        width: 160,
        margin: const EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Color(0xFF4268D3), Color(0xFF574ACF)],
            begin: FractionalOffset(0.0, 0.5),
            end: FractionalOffset(1.0, 0.5),
            stops: [0.0, 0.5],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: Text(
            textoBoton,
            style: const TextStyle(
              fontFamily: "Lato",
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
