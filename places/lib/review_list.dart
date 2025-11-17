import 'package:flutter/cupertino.dart';
import 'package:places/review.dart';

class ReviewList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final reviewList = Column(
        children: <Widget>[
          Review("assets/images/persona1.jpg", "Roberto Magno", "1 reviews - 3 photos", 4, "lugar interesante ! D:"),
          Review("assets/images/persona2.jpg", "Lusia Ramos", "4 reviews - 2 photos", 4, "Les recomiendo este lugar.. :D"),
          Review("assets/images/persona3.jpg", "Mijael Alvares", "3 reviews - 2 photos", 5, "Bastante lejos pero lo vale..."),
          Review("assets/images/persona4.jpg", "Fernando Solis", "8 reviews - 4 photos", 3, "EL lugar es interesante!"),
          Review("assets/images/persona5.jpg", "Carlos Cuellar", "3 reviews - 4 photos", 3, "Quiero ir a mi casita!!! :D!"),
        ]
    );

    return reviewList;
  }
}