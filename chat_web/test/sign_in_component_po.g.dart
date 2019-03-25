// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_component_po.dart';

// **************************************************************************
// PageObjectGenerator
// **************************************************************************

// ignore_for_file: private_collision_in_mixin_application
class $SignInComponentPO extends SignInComponentPO with $$SignInComponentPO {
  PageLoaderElement $__root__;
  $SignInComponentPO.create(PageLoaderElement currentContext)
      : $__root__ = currentContext {
    $__root__.addCheckers([]);
  }
  factory $SignInComponentPO.lookup(PageLoaderSource source) =>
      throw "'lookup' constructor for class "
      "SignInComponentPO is not generated and can only be used on Page Object "
      "classes that have @CheckTag annotation.";
  static String get tagName =>
      throw '"tagName" is not defined by Page Object "SignInComponentPO". Requires @CheckTag annotation in order for "tagName" to be generated.';
  String toStringDeep() => 'SignInComponentPO\n\n${$__root__.toStringDeep()}';
}

class $$SignInComponentPO {
  PageLoaderElement $__root__;
  PageLoaderMouse __mouse__;
  PageLoaderElement get $root => $__root__;
  PageLoaderElement get usernameInput {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('SignInComponentPO', 'usernameInput');
    }
    final element =
        $__root__.createElement(First(ByCss('input[type=text]')), [], []);
    final returnMe = element;
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('SignInComponentPO', 'usernameInput');
    }
    return returnMe;
  }

  PageLoaderElement get psswordInput {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('SignInComponentPO', 'psswordInput');
    }
    final element =
        $__root__.createElement(First(ByCss('input[type=password]')), [], []);
    final returnMe = element;
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('SignInComponentPO', 'psswordInput');
    }
    return returnMe;
  }

  PageLoaderElement get usernameMaterialInput {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod(
          'SignInComponentPO', 'usernameMaterialInput');
    }
    final element = $__root__
        .createElement(First(ByCss('material-input[type=text]')), [], []);
    final returnMe = element;
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod(
          'SignInComponentPO', 'usernameMaterialInput');
    }
    return returnMe;
  }

  PageLoaderElement get passwordMaterialInput {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod(
          'SignInComponentPO', 'passwordMaterialInput');
    }
    final element = $__root__
        .createElement(First(ByCss('material-input[type=password]')), [], []);
    final returnMe = element;
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod(
          'SignInComponentPO', 'passwordMaterialInput');
    }
    return returnMe;
  }

  PageLoaderElement get signInButton {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('SignInComponentPO', 'signInButton');
    }
    final element =
        $__root__.createElement(First(ByCss('material-button')), [], []);
    final returnMe = element;
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('SignInComponentPO', 'signInButton');
    }
    return returnMe;
  }
}
