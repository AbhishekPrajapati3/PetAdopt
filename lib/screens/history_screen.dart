import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/pet_bloc.dart';

import '../widgets/pet_tile.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PetBloc, PetState>(
      builder: (context, state) {
        if (state is PetLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is PetLoaded) {
          final adoptedPets = state.pets.where((pet) => pet.isAdopted).toList();
          if (adoptedPets.isEmpty) {
            return Center(child: Text('No adoption history yet.'));
          }

          return GridView.builder(
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.75,
            ),
            itemCount: adoptedPets.length,
            itemBuilder: (context, index) {
              return PetTile(pet: adoptedPets[index]);
            },
          );
        } else if (state is PetError) {
          return Center(child: Text('Failed to load adoption history.'));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
