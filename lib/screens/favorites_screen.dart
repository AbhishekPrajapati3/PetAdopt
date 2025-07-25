import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/pet_bloc.dart';
import '../widgets/pet_tile.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PetBloc, PetState>(
      builder: (context, state) {
        if (state is PetLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is PetLoaded) {
          final favoritePets = state.pets.where((pet) => pet.isFavorite).toList();
          if (favoritePets.isEmpty) {
            return Center(child: Text('No favorites yet.'));
          }
          return GridView.builder(
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.75,
            ),
            itemCount: favoritePets.length,
            itemBuilder: (context, index) => PetTile(pet: favoritePets[index]),
          );
        } else if (state is PetError) {
          return Center(child: Text('Failed to load favorites.'));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
