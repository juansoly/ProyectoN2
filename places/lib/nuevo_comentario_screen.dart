import 'package:flutter/material.dart';
import 'auth_service.dart';

class NuevoComentarioScreen extends StatefulWidget {
  final int idLugar;
  NuevoComentarioScreen({required this.idLugar});

  @override
  _NuevoComentarioScreenState createState() => _NuevoComentarioScreenState();
}

class _NuevoComentarioScreenState extends State<NuevoComentarioScreen> {
  final TextEditingController _controller = TextEditingController();
  int _calificacion = 5;
  bool _isLoading = false; // Variable para controlar el estado de carga

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Escribe tu experiencia")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "¿Qué te pareció este lugar?",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text("Calificación: $_calificacion estrellas"),
            Slider(
              value: _calificacion.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              onChanged: (val) => setState(() => _calificacion = val.toInt()),
            ),
            SizedBox(height: 20),

            // Botón con estado de carga
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () async {
                if (_controller.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Por favor, escribe un comentario")));
                  return;
                }

                setState(() => _isLoading = true);

                try {
                  // Llamamos a AuthService
                  bool exito = await AuthService().guardarComentario(
                      widget.idLugar,
                      _controller.text,
                      _calificacion
                  );

                  if (exito) {
                    Navigator.pop(context, true); // Regresamos 'true' para indicar éxito
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Comentario guardado exitosamente")));
                  } else {
                    throw Exception("Error del servidor");
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("No se pudo guardar: ${e.toString()}")));
                } finally {
                  if (mounted) setState(() => _isLoading = false);
                }
              },
              child: Text("Publicar Comentario"),
            ),
          ],
        ),
      ),
    );
  }
}