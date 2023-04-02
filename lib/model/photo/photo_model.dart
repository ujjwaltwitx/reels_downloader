import 'package:hive/hive.dart';
part 'photo_model.g.dart';

@HiveType(typeId: 2)
class PhotoModel {
  PhotoModel(this.photoId, this.toSendLink, this.photoPath);

  @HiveField(0)
  final String photoId;

  @HiveField(1)
  final String photoPath;

  @HiveField(2)
  final String toSendLink;
}
