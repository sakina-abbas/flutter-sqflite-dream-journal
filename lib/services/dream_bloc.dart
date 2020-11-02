import 'services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DreamBloc extends Bloc<DreamEvent, List<Dream>> {
  DreamBloc(List<Dream> initialState) : super(initialState);

  @override
  Stream<List<Dream>> mapEventToState(DreamEvent event) async* {
    if (event is SetDreams) {
      yield event.dreamsList;
    } else if (event is AddDream) {
      List<Dream> newState = List.from(state);
      if (event.newDream != null) {
        newState.insert(0, event.newDream);
      }
      yield newState;
    } else if (event is DeleteDream) {
      List<Dream> newState = List.from(state);
      newState.removeAt(event.dreamIndex);
      yield newState;
    } else if (event is UpdateDream) {
      List<Dream> newState = List.from(state);
      newState[event.dreamIndex] = event.newDream;
      yield newState;
    }
  }
}
