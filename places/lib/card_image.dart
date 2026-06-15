import 'package:flutter/material.dart';
import 'package:places/auth_service.dart';

class CardImage extends StatefulWidget {
  final String path;
  final int idLugar;

  CardImage(this.path, this.idLugar);

  @override
  _CardImageState createState() => _CardImageState();
}

class _CardImageState extends State<CardImage> {
  final AuthService _authService = AuthService();
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _verificarEstadoInicial();
  }

  // Verificamos si ya es favorito al cargar la tarjeta
  void _verificarEstadoInicial() async {
    bool estado = await _authService.verificarLike(widget.idLugar);
    if (mounted) {
      setState(() {
        _isLiked = estado;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 80, left: 20),
      child: Stack(
        children: [
          // Capa 1: La Imagen
          Container(
            height: 250,
            width: 250,
            decoration: BoxDecoration(
              image: DecorationImage(fit: BoxFit.cover, image: AssetImage(widget.path)),
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(color: Colors.black38, blurRadius: 15, offset: Offset(0, 7))
              ],
            ),
          ),

          // Capa 2: El Corazón
          Positioned(
            bottom: 10,
            left: 10,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              mini: true,
              onPressed: () async {
                String? resultado = await _authService.toggleLike(widget.idLugar);
                if (resultado != null) {
                  // Cambiamos el estado para que el icono se pinte
                  setState(() {
                    _isLiked = !_isLiked;
                  });
                }
              },
              // Si _isLiked es true, mostramos el corazón lleno (Icons.favorite)
              child: Icon(
                _isLiked ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}