import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:places/auth_service.dart';

class ComentariosScreen extends StatefulWidget {
  final int idLugar;
  final bool abrirDirectamenteComentar;

  ComentariosScreen({
    required this.idLugar,
    this.abrirDirectamenteComentar = false
  });

  @override
  _ComentariosScreenState createState() => _ComentariosScreenState();
}

class _ComentariosScreenState extends State<ComentariosScreen> {
  final TextEditingController _textController = TextEditingController();
  int _calificacion = 5;
  List<dynamic> _comentarios = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarComentarios();
  }

  Future<void> _cargarComentarios() async {
    setState(() => _isLoading = true);
    var lista = await AuthService().obtenerComentariosPorLugar(widget.idLugar);
    if (mounted) {
      setState(() {
        _comentarios = lista;
        _isLoading = false;
      });
    }
  }

  Future<void> _publicarComentario() async {
    if (_textController.text.isEmpty) return;

    // --- MEJORA: Validación de sesión antes de enviar ---
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Debes iniciar sesión para publicar un comentario"))
      );
      return;
    }

    // --- Intentar guardar ---
    bool exito = await AuthService().guardarComentario(
        widget.idLugar,
        _textController.text,
        _calificacion
    );

    if (exito) {
      _textController.clear();
      _cargarComentarios(); // Recarga la lista automáticamente
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("¡Comentario publicado!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error al publicar. Inténtalo de nuevo.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Comentarios")),
      body: Column(
        children: [
          if (widget.abrirDirectamenteComentar)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                        labelText: "Escribe tu experiencia",
                        border: OutlineInputBorder()
                    ),
                  ),
                  Slider(
                    value: _calificacion.toDouble(),
                    min: 1, max: 5, divisions: 4,
                    label: "$_calificacion estrellas",
                    onChanged: (val) => setState(() => _calificacion = val.toInt()),
                  ),
                  ElevatedButton(
                    onPressed: _publicarComentario,
                    child: Text("Publicar Comentario"),
                  ),
                ],
              ),
            ),

          Divider(),

          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _comentarios.isEmpty
                ? Center(child: Text("No hay comentarios todavía."))
                : ListView.builder(
              itemCount: _comentarios.length,
              itemBuilder: (context, index) {
                final c = _comentarios[index];
                return ListTile(
                  leading: CircleAvatar(child: Text(c['calificacion'].toString())),
                  title: Text(c['textoComentario'] ?? "Sin texto"),
                  subtitle: Text("Fecha: ${c['fechaComentario'] ?? 'N/A'}"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}