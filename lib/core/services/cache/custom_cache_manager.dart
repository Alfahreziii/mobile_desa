import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomCacheManager {
  static CacheManager instance = CacheManager(
    Config(
      'customCacheKey', // Nama unik cache
      stalePeriod: const Duration(days: 7), // File akan dihapus setelah 7 hari
      maxNrOfCacheObjects: 100, // Maksimal 100 file dalam cache
      repo: JsonCacheInfoRepository(databaseName: 'customCache'),
      fileService: HttpFileService(),
    ),
  );
}
