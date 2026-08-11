import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tasks/features/todo/data/models/todo_isar_model.dart';

@module
abstract class IsarModule {
  @preResolve
  @lazySingleton
  Future<Isar> get isar async {
    final dir = await getApplicationDocumentsDirectory();

    return Isar.open([TodoIsarModelSchema], directory: dir.path);
  }
}
