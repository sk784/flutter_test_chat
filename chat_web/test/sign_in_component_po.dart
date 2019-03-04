import 'package:pageloader/pageloader.dart';

part 'sign_in_component_po.g.dart';

@PageObject()
abstract class SignInComponentPO {
  SignInComponentPO();
  // ignore: redirect_to_non_class
  factory SignInComponentPO.create(PageLoaderElement context) = $SignInComponentPO.create;

  @First(ByCss('material-input[type=text]'))
  PageLoaderElement get _usernameInput;

  @First(ByCss('material-input[type=password]'))
  PageLoaderElement get _psswordInput;

  PageLoaderElement get usernameInput => _usernameInput;
  PageLoaderElement get psswordInput => _psswordInput;
}