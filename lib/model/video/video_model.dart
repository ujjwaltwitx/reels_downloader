import 'package:hive/hive.dart';
part 'video_model.g.dart';

@HiveType(typeId: 1)
class VideoModel {
  VideoModel({
    required this.videoId,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.ownerId,
    required this.ownerThumbnailUrl,
    required this.videoPath,
    required this.thumbnailPath,
    required this.viewCount,
  });

  @HiveField(0)
  final String videoId;

  @HiveField(1)
  final String ownerId;

  @HiveField(2)
  final String thumbnailUrl;

  @HiveField(3)
  final String videoUrl;

  @HiveField(4)
  final String ownerThumbnailUrl;

  @HiveField(5)
  final String videoPath;

  @HiveField(6)
  final String thumbnailPath;

  @HiveField(7)
  final int viewCount;
}
