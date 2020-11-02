import 'models.dart';

abstract class DreamEvent {}

class SetDreams extends DreamEvent {
  List<Dream> dreamsList;

  SetDreams(List<Dream> dreams) {
    dreamsList = dreams;
  }
}

class AddDream extends DreamEvent {
  Dream newDream;

  AddDream(Dream dream) {
    newDream = dream;
  }
}

class DeleteDream extends DreamEvent {
  int dreamIndex;

  DeleteDream(int index) {
    dreamIndex = index;
  }
}

class UpdateDream extends DreamEvent {
  Dream newDream;
  int dreamIndex;

  UpdateDream(int index, Dream dream) {
    newDream = dream;
    dreamIndex = index;
  }
}