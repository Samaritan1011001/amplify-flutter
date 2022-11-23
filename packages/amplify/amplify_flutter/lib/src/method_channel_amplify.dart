/*
 * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

// ignore_for_file: invalid_use_of_visible_for_testing_member

part of 'amplify_impl.dart';

const MethodChannel _channel = MethodChannel('com.amazonaws.amplify/amplify');

/// {@template amplify.method_channel_amplify}
/// An implementation of [AmplifyClass] that uses method channels.
/// {@endtemplate}
class MethodChannelAmplify extends AmplifyClassImpl {
  /// {@macro amplify.method_channel_amplify}
  MethodChannelAmplify() : super.protected();
  static final AmplifyLogger _logger =
      AmplifyLogger.category(Category.notifications)
          .createChild('MethodChannelAmplify');
  @override
  Future<void> addPlugin(AmplifyPluginInterface plugin) async {
    _logger.info('addPlugin in MethodChannelAmplify called');

    if (isConfigured) {
      throw const AmplifyAlreadyConfiguredException(
        'Amplify has already been configured and adding plugins after configure is not supported.',
        recoverySuggestion:
            'Check if Amplify is already configured using Amplify.isConfigured.',
      );
    }
    try {
      if (plugin is AuthPluginInterface) {
        await Auth.addPlugin(
          plugin,
          authProviderRepo: authProviderRepo,
        );
      } else if (plugin is AnalyticsPluginInterface) {
        await Analytics.addPlugin(
          plugin,
          authProviderRepo: authProviderRepo,
        );
      } else if (plugin is StoragePluginInterface) {
        await Storage.addPlugin(
          plugin,
          authProviderRepo: authProviderRepo,
        );
      } else if (plugin is DataStorePluginInterface) {
        try {
          await DataStore.addPlugin(
            plugin,
            authProviderRepo: authProviderRepo,
          );
        } on AmplifyAlreadyConfiguredException {
          // A new plugin is added in native libraries during `addPlugin`
          // call for DataStore, which means during an app restart, this
          // method will throw an exception in android. We will ignore this
          // like other plugins and move on. Other exceptions fall through.
        }
        Hub.addChannel(
          HubChannel.DataStore,
          plugin.streamController.stream,
        );
      } else if (plugin is APIPluginInterface) {
        await API.addPlugin(
          plugin,
          authProviderRepo: authProviderRepo,
        );
      } else if (plugin is NotificationsPluginInterface) {
        _logger.info('Notfication plugin added in amplify_flutter -> $plugin');

        await Notifications.addPlugin(
          plugin,
          authProviderRepo: authProviderRepo,
        );
      } else {
        throw AmplifyException(
          'The type of plugin ${plugin.runtimeType} is not yet supported '
          'in Amplify.',
          recoverySuggestion:
              AmplifyExceptionMessages.missingRecoverySuggestion,
        );
      }
    } on Exception catch (e) {
      safePrint('Amplify plugin was not added');
      throw AmplifyException(
        'Amplify plugin ${plugin.runtimeType} was not added successfully.',
        recoverySuggestion: AmplifyExceptionMessages.missingRecoverySuggestion,
        underlyingException: e.toString(),
      );
    }
  }

  @override
  Future<void> addPlugins(List<AmplifyPluginInterface> plugins) {
    return Future.wait(plugins.map(addPlugin));
  }

  @override
  Future<void> configurePlatform(String config) async {
    try {
      // _logger.info('configurePlatform in amplify_flutter called');

      await _channel.invokeMethod<void>(
        'configure',
        <String, Object>{
          'version': version,
          'configuration': config,
        },
      );
<<<<<<< HEAD
      // _logger.info('Native configure is called and finished');

=======
>>>>>>> bb9c38b06052a371e7668bfea1cf827032979ca2
    } on PlatformException catch (e) {
      if (e.code == 'AmplifyException') {
        throw AmplifyException.fromMap(
          Map<String, String>.from(e.details as Map),
        );
      } else if (e.code == 'AmplifyAlreadyConfiguredException') {
        return;
      } else {
        // This shouldn't happen. All exceptions coming from platform for
        // amplify_flutter should have a known code. Throw an unknown error.
        throw AmplifyException(AmplifyExceptionMessages.missingExceptionMessage,
            recoverySuggestion:
                AmplifyExceptionMessages.missingRecoverySuggestion,
            underlyingException: e.toString());
      }
    }
  }
<<<<<<< HEAD

  @override
  Future<void> reset() async {
    Auth.plugins.clear();
    Analytics.plugins.clear();
    Storage.plugins.clear();
    DataStore.plugins.clear();
    API.plugins.clear();
    Notifications.plugins.clear();
  }
=======
>>>>>>> bb9c38b06052a371e7668bfea1cf827032979ca2
}
