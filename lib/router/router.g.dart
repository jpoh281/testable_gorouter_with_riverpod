// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$routerHash() => r'36bc653959bf7731c3a1735ea849b31a277a007c';

/// See also [router].
@ProviderFor(router)
final routerProvider = AutoDisposeProvider<AppRouter>.internal(
  router,
  name: r'routerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$routerHash,
  dependencies: <ProviderOrFamily>{
    routerNotifierProvider,
    splashScreenInterceptorProvider,
    authScreenInterceptorProvider,
    needAuthScreenInterceptorProvider
  },
  allTransitiveDependencies: <ProviderOrFamily>{
    routerNotifierProvider,
    splashScreenInterceptorProvider,
    authScreenInterceptorProvider,
    needAuthScreenInterceptorProvider,
    authNotifierProvider
  },
);

typedef RouterRef = AutoDisposeProviderRef<AppRouter>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
