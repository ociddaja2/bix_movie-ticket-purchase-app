import 'package:flutter/material.dart';
import 'package:bixcinema/core/models/teater_model.dart';
import 'package:bixcinema/core/repo/teater_repo.dart';

/// Provider/State untuk menyimpan pilihan kota dan teater user
class CityTeaterProvider with ChangeNotifier {
  final TeaterRepository _teaterRepository = TeaterRepository();

  String? _selectedCity;
  String? _selectedTeaterId;
  List<String> _cities = [];
  List<TeaterModel> _teaters = [];

  // Getter
  String? get selectedCity => _selectedCity;
  String? get selectedTeaterId => _selectedTeaterId;
  List<String> get cities => _cities;
  List<TeaterModel> get teaters => _teaters;

  /// Initialize: Load semua kota
  Future<void> initialize() async {
  try {
    print('Fetching unique cities...');
    _cities = await _teaterRepository.fetchUniqueCities();
    print('Cities fetched: $_cities');
    
    if (_cities.isNotEmpty) {
      _selectedCity = _cities.first;
      print('Selected city: $_selectedCity');
      
      await _selectCity(_cities.first);
      print('_selectCity completed');
      print('Selected teater ID: $_selectedTeaterId');
      print('Selected teaters: ${_teaters.length} teater found');
    } else {
      print('No cities found in database!');
    }
    notifyListeners();
  } catch (e) {
    print('Error in initialize: $e');
  }
}


  /// Select kota dan load teater di kota tersebut
  Future<void> selectCity(String city) async {
    _selectedCity = city;
    await _selectCity(city);
    notifyListeners();
  }

  Future<void> _selectCity(String city) async {
  try {
    print('Fetching teater for city: $city');
    _teaters = await _teaterRepository.fetchTeaterByCity(city);
    print('Teaters fetched: ${_teaters.length}');
    
    if (_teaters.isNotEmpty) {
      _selectedTeaterId = _teaters.first.teaterId;
      print('Selected teater ID: $_selectedTeaterId');
    } else {
      print('No teater found for city: $city');
    }
  } catch (e) {
    print('Error in _selectCity: $e');
  }
}

  /// Select teater
  void selectTeater(String teaterId) {
    _selectedTeaterId = teaterId;
    notifyListeners();
  }

  /// Get teater saat ini
  TeaterModel? get currentTeater {
    if (_selectedTeaterId == null) return null;
    try {
      return _teaters.firstWhere((t) => t.teaterId == _selectedTeaterId);
    } catch (e) {
      return null;
    }
  }
}
