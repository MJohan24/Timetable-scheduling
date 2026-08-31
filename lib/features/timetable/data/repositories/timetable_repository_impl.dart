import '../../domain/entities/train_schedule.dart';
import '../../domain/repositories/timetable_repository.dart';
import '../datasources/timetable_local_data_source.dart';
import '../datasources/timetable_remote_data_source.dart';

class TimetableRepositoryImpl implements TimetableRepository {
  const TimetableRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final TimetableRemoteDataSource remoteDataSource;
  final TimetableLocalDataSource localDataSource;

  @override
  Future<List<TrainSchedule>> getSchedules({
    String? station,
    String? trainType,
    bool? isWeekend,
  }) async {
    // Jika tidak ada stasiun dipilih, gunakan data lokal sebagai fallback.
    if (station == null || station == 'Semua Stasiun') {
      return _filterLocal(trainType: trainType, isWeekend: isWeekend);
    }

    try {
      // Coba ambil dari remote API terlebih dahulu.
      final remoteSchedules = await remoteDataSource.getSchedules(
        station: station,
        trainType: trainType,
        isWeekend: isWeekend,
      );

      // Jika remote kosong, fallback ke data lokal untuk stasiun tersebut.
      if (remoteSchedules.isEmpty) {
        final local = _filterLocal(
          station: station,
          trainType: trainType,
          isWeekend: isWeekend,
        );
        return local.isNotEmpty ? local : remoteSchedules;
      }

      return remoteSchedules;
    } catch (error) {
      // Jaringan/cold-start: pakai lokal jika ada. Jangan anggap timeout
      // sebagai jadwal kosong ketika fallback lokal juga kosong.
      final local = _filterLocal(
        station: station,
        trainType: trainType,
        isWeekend: isWeekend,
      );
      if (local.isNotEmpty) return local;
      rethrow;
    }
  }

  /// Filter data lokal berdasarkan parameter yang diberikan.
  List<TrainSchedule> _filterLocal({
    String? station,
    String? trainType,
    bool? isWeekend,
  }) {
    return localDataSource.getSchedules().where((s) {
      final matchStation =
          station == null ||
          station == 'Semua Stasiun' ||
          s.stationName.toLowerCase() == station.toLowerCase();
      final matchType =
          trainType == null || trainType == 'Semua' || s.trainType == trainType;
      final matchWeekend = isWeekend == null || s.isWeekend == isWeekend;
      return matchStation && matchType && matchWeekend;
    }).toList();
  }
}
