import 'package:hive/hive.dart';
part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  UserModel(this.usrname, this.thumbnailUrl);

  @HiveField(0)
  final String usrname;

  @HiveField(1)
  final String thumbnailUrl;
}
