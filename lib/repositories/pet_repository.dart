import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../models/pet.dart';

class PetRepository {
  static Future<List<Pet>> fetchPets() async {
    final box = Hive.box('petBox');
    if (box.containsKey('pets')) {
      final petsData = box.get('pets');
      final petsList = (jsonDecode(petsData) as List)
          .map((e) => Pet.fromJson(e))
          .toList();
      return petsList;
    }

    final response = await http.get(
        Uri.parse('https://mocki.io/v1/bbfd0438-1f2d-47bb-963a-74f181be4f12'));

    if (response.statusCode == 200) {
      print('API Response: ${response.body}');
      final petsList = (jsonDecode(response.body) as List).map((e) {
        var pet = Pet.fromJson(e);

        pet.isAdopted = false;
        pet.isFavorite = false;
        return pet;
      }).toList();
      await savePetsToLocal(petsList);
      return petsList;
    } else {
      throw Exception('Failed to load pets');
    }
  }

  static Future<void> savePetsToLocal(List<Pet> pets) async {
    final box = Hive.box('petBox');
    box.put('pets', jsonEncode(pets.map((e) => e.toJson()).toList()));
  }

  static Future<void> updatePet(Pet pet) async {
    final box = Hive.box('petBox');
    final petsData = box.get('pets');
    final petsList = (jsonDecode(petsData) as List)
        .map((e) => Pet.fromJson(e))
        .toList();

    final index = petsList.indexWhere((p) => p.id == pet.id);
    if (index != -1) {
      petsList[index] = pet;
      box.put('pets', jsonEncode(petsList.map((e) => e.toJson()).toList()));
    }
  }
}
