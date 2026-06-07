import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'LMS_BASE_URL', obfuscate: true)
  static final String lmsBaseUrl = _Env.lmsBaseUrl;
}
