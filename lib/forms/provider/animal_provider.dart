import 'package:adoptanddonate_new/screens/animals_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AnimalProvider with ChangeNotifier{
  late DocumentSnapshot animalData;
  DocumentSnapshot? donorDetails;
 
 Animal? _currentAnimal;

  Animal? get currentAnimal => _currentAnimal;

    void setAnimalData(Animal animal) {
    _currentAnimal = animal;
    notifyListeners();
  }
  getAnimalDetails(details){
    this.animalData=details;
    notifyListeners();
  }
  
  getDonorDetails(details){
    this.donorDetails=details;
    notifyListeners();
  }
}