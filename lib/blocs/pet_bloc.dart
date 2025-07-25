import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/pet.dart';
import '../repositories/pet_repository.dart';

abstract class PetEvent {}
class FetchPetsEvent extends PetEvent {}
class AdoptPetEvent extends PetEvent { final String petId; AdoptPetEvent(this.petId); }
class ToggleFavoriteEvent extends PetEvent { final String petId; ToggleFavoriteEvent(this.petId);
}

abstract class PetState {}
class PetInitial extends PetState {}
class PetLoading extends PetState {}
class PetLoaded extends PetState {
  final List<Pet> pets;
  PetLoaded(this.pets);
}
class PetError extends PetState {}

class PetBloc extends Bloc<PetEvent, PetState> {
  PetBloc() : super(PetInitial()) {
    on<FetchPetsEvent>((event, emit) async {
      emit(PetLoading());
      try {
        final pets = await PetRepository.fetchPets();
        emit(PetLoaded(pets));
      } catch (_) {
        emit(PetError());
      }
    });

    on<AdoptPetEvent>((event, emit) async {
      if (state is PetLoaded) {
        final pets = (state as PetLoaded).pets;
        final index = pets.indexWhere((p) => p.id == event.petId);
        if (index != -1) {
          pets[index].isAdopted = true;
          await PetRepository.savePetsToLocal(pets);
          emit(PetLoaded(List.from(pets)));
        }
      }
    });

    on<ToggleFavoriteEvent>((event, emit) async {
      if (state is PetLoaded) {
        final pets = (state as PetLoaded).pets;
        final index = pets.indexWhere((p) => p.id == event.petId);
        if (index != -1) {
          pets[index].isFavorite = !pets[index].isFavorite;
          await PetRepository.savePetsToLocal(pets);
          emit(PetLoaded(List.from(pets)));
        }
      }
    });
  }
}