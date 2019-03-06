// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_component_po.dart';

// **************************************************************************
// PageObjectGenerator
// **************************************************************************

// ignore_for_file: private_collision_in_mixin_application
// ignore_for_file: unused_field, non_constant_identifier_names
// ignore_for_file: overridden_fields, annotate_overrides
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
  PageLoaderElement get usernameInput {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('SignInComponentPO', 'usernameInput');
    }
    final returnMe = super.usernameInput;
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('SignInComponentPO', 'usernameInput');
    }
    return returnMe;
  }
}

class $$SignInComponentPO {
  PageLoaderElement $__root__;
  PageLoaderMouse __mouse__; // ignore: unused_field
  PageLoaderElement get $root => $__root__;
  PageLoaderElement get _usernameInput {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('SignInComponentPO', '_usernameInput');
    }
    final element = $__root__
        .createElement(First(ByCss('material-input[type=text]')), [], []);
    final returnMe = element;
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('SignInComponentPO', '_usernameInput');
    }
    return returnMe;
  }
}
