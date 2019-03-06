import 'package:pageloader/pageloader.dart';

part 'sign_in_component_po.g.dart';

@PageObject()
abstract class SignInComponentPO {
  SignInComponentPO();
  factory SignInComponentPO.create(PageLoaderElement context) = $SignInComponentPO.create;

  @First(ByCss('material-input[type=text]'))
  PageLoaderElement get _usernameInput;

  PageLoaderElement get usernameInput => _usernameInput;
}