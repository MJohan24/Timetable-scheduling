import '../../data/datasources/timetable_local_data_source.dart';
import '../../data/datasources/timetable_remote_data_source.dart';
import '../../data/repositories/timetable_repository_impl.dart';
import '../../domain/entities/train_schedule.dart';
import '../../domain/usecases/get_timetable.dart';

class TimetableController {
  TimetableController()
    : _getTimetable = GetTimetable(
        TimetableRepositoryImpl(
          remoteDataSource: TimetableRemoteDataSource(),
          localDataSource: const TimetableLocalDataSource(),
        ),
      );

  final GetTimetable _getTimetable;

  Future<List<TrainSchedule>> loadSchedules({
    String? station,
    String? trainType,
    bool? isWeekend,
  }) {
    return _getTimetable(
      station: station,
      trainType: trainType,
      isWeekend: isWeekend,
    );
  }
}
