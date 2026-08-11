import 'package:equatable/equatable.dart';

class TodoEntity extends Equatable {
  final String? id;
  final String title;
  final String? description;
  final bool? isDone;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TodoEntity({
    this.id,
    required this.title,
    this.description,
    this.isDone,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    isDone,
    createdAt,
    updatedAt,
  ];
}
