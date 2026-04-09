part of 'create_quiz_cubit.dart';

sealed class CreateQuizState extends Equatable {
  const CreateQuizState();

  @override
  List<Object?> get props => [];
}

final class CreateQuizInitial extends CreateQuizState {}

final class CreateQuizUIUpdated extends CreateQuizState {
  final DateTime timestamp;
  const CreateQuizUIUpdated(this.timestamp);

  @override
  List<Object?> get props => [timestamp];
}

final class CreateQuizLoading extends CreateQuizState {}

final class CreateQuizSuccess extends CreateQuizState {
  final String message;
  const CreateQuizSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

final class CreateQuizFailure extends CreateQuizState {
  final String message;
  const CreateQuizFailure(this.message);

  @override
  List<Object?> get props => [message];
}
