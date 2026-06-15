import 'package:flutter/material.dart';
import 'card_image.dart';

class CardImageList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      child: ListView(
        padding: EdgeInsets.all(25),
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          // Aquí pasas el path y el ID real de tu base de datos
          CardImage("assets/images/lugar1.jpg", 1),
          CardImage("assets/images/lugar2.jpg", 2),
          CardImage("assets/images/lugar3.jpg", 3),
          CardImage("assets/images/lugar4.jpg", 4),
          CardImage("assets/images/lugar5.jpg", 5),
          CardImage("assets/images/lugar6.jpg", 6),
        ],
      ),
    );
  }
}