import 'package:flutter/material.dart';
import 'package:places/auth_service.dart'; // Ajusta la ruta si es necesario
class LugarSearchDelegate extends SearchDelegate {
  final AuthService _authService = AuthService();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(icon: Icon(Icons.arrow_back), onPressed: () => close(context, null));
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _authService.buscarLugares(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        final lugares = snapshot.data!;
        return ListView.builder(
          itemCount: lugares.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(lugares[index]['nombre']),
            onTap: () { /* Navegar al detalle del lugar */ },
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) => Container(); // Opcional
}