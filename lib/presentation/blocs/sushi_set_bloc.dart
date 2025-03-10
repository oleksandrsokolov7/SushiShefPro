import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/sushi_set_model.dart';
import '../../data/repositories/sushi_set_repository.dart';

abstract class SushiSetEvent {}

class LoadSushiSets extends SushiSetEvent {
  final String userId;
  final bool showOwnSets;

  LoadSushiSets(this.userId, this.showOwnSets);
}

class AddSushiSet extends SushiSetEvent {
  final SushiSet set;

  AddSushiSet(this.set);
}

class UpdateSushiSet extends SushiSetEvent {
  final SushiSet set;

  UpdateSushiSet(this.set);
}

class DeleteSushiSet extends SushiSetEvent {
  final String setId;

  DeleteSushiSet(this.setId);
}

abstract class SushiSetState {}

class SushiSetInitial extends SushiSetState {}

class SushiSetLoading extends SushiSetState {}

class SushiSetLoaded extends SushiSetState {
  final List<SushiSet> sets;

  SushiSetLoaded(this.sets);
}

class SushiSetError extends SushiSetState {
  final String message;

  SushiSetError(this.message);
}

class SushiSetBloc extends Bloc<SushiSetEvent, SushiSetState> {
  final SushiSetRepository _repository;

  SushiSetBloc(this._repository) : super(SushiSetInitial()) {
    on<LoadSushiSets>(_onLoadSushiSets);
    on<AddSushiSet>(_onAddSushiSet);
    on<UpdateSushiSet>(_onUpdateSushiSet);
    on<DeleteSushiSet>(_onDeleteSushiSet);
  }

  Future<void> _onLoadSushiSets(
      LoadSushiSets event, Emitter<SushiSetState> emit) async {
    emit(SushiSetLoading());
    try {
      final sets = await _repository.loadSets(
        userId: event.userId,
        own: event.showOwnSets,
      );
      emit(SushiSetLoaded(sets));
    } catch (e) {
      emit(SushiSetError('Ошибка загрузки сетов: $e'));
    }
  }

  Future<void> _onAddSushiSet(
      AddSushiSet event, Emitter<SushiSetState> emit) async {
    try {
      await _repository.saveSet(event.set);
      add(LoadSushiSets(event.set.ownerId, true));
    } catch (e) {
      emit(SushiSetError('Ошибка добавления сета: $e'));
    }
  }

  Future<void> _onUpdateSushiSet(
      UpdateSushiSet event, Emitter<SushiSetState> emit) async {
    try {
      // Логика обновления
    } catch (e) {
      emit(SushiSetError('Ошибка обновления сета: $e'));
    }
  }

  Future<void> _onDeleteSushiSet(
      DeleteSushiSet event, Emitter<SushiSetState> emit) async {
    try {
      // Логика удаления
    } catch (e) {
      emit(SushiSetError('Ошибка удаления сета: $e'));
    }
  }
}
