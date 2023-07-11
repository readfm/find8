import '../security/generator/random_key_pair_generator.dart';
import '../security/key_pair.dart';
import 'app.dart';

class UserNostr {
  late KeyPair keyPair;

  UserNostr() {
    keyPair = RandomKeyPairGenerator().generate();
    // upload key pair to server

    // download key pair from server
  }
}
