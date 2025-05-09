import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;

  // Veritabanı erişimi
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  // Veritabanı başlatma
  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        // Veritabanı tablosu oluşturma
        db.execute('''CREATE TABLE workers(
          id INTEGER PRIMARY KEY,
          name TEXT,
          phone TEXT,
          wage REAL,
          remaining_wage REAL
        )''');
      },
    );
  }

  // Yedekleme işlemi
  Future<void> backupData() async {
    try {
      final db = await database;
      // Veritabanı dosyasının yolunu al
      String dbPath = await getDatabasesPath();
      String backupPath = join(await _getBackupDirectory(), 'app_database_backup.db');

      // Veritabanı dosyasını yedekleme
      File sourceFile = File(join(dbPath, 'app_database.db'));
      File backupFile = File(backupPath);

      await sourceFile.copy(backupFile.path);
      print('Yedekleme başarılı: $backupPath');
    } catch (e) {
      print('Yedekleme sırasında bir hata oluştu: $e');
    }
  }

  // Yedek veriyi geri yükleme işlemi
  Future<void> restoreData() async {
    try {
      final db = await database;
      // Yedek veritabanı dosyasının yolunu al
      String backupPath = join(await _getBackupDirectory(), 'app_database_backup.db');
      String dbPath = await getDatabasesPath();

      // Yedek veritabanı dosyasını geri yükleme
      File backupFile = File(backupPath);
      File destinationFile = File(join(dbPath, 'app_database.db'));

      await backupFile.copy(destinationFile.path);
      print('Veri geri yüklendi: $dbPath');
    } catch (e) {
      print('Geri yükleme sırasında bir hata oluştu: $e');
    }
  }

  // Yedekleme için uygun bir dizin almak
  Future<String> _getBackupDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path; // Yedeklemeyi belgeler dizinine kaydediyoruz
  }

  // Veritabanı verilerini listelemek (örnek)
  Future<List<Map<String, dynamic>>> getWorkers() async {
    final db = await database;
    return await db.query('workers');
  }

  // Veritabanına veri eklemek (örnek)
  Future<void> insertWorker(Map<String, dynamic> worker) async {
    final db = await database;
    await db.insert(
      'workers',
      worker,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Veritabanından veri silmek (örnek)
  Future<void> deleteWorker(int id) async {
    final db = await database;
    await db.delete(
      'workers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
