import 'package:hive/hive.dart';
part 'video_model.g.dart';

@HiveType(typeId: 1)
class VideoModel {
  VideoModel(this.videoId, this.videoUrl, this.thumbnailUrl, this.ownerId,
      this.ownerThumbnailUrl, this.videoPath, this.thumbnailPath);

  @HiveField(0)
  final String thumbnailUrl;

  @HiveField(1)
  final String videoUrl;

  @HiveField(2)
  final String videoId;

  @HiveField(3)
  final String ownerId;

  @HiveField(4)
  final String ownerThumbnailUrl;

  @HiveField(5)
  final String videoPath;

  @HiveField(6)
  final String thumbnailPath;
}
