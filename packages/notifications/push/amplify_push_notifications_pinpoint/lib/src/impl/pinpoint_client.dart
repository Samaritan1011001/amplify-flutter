import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_push_notifications_pinpoint/endpoint_client.dart';
import 'package:amplify_push_notifications_pinpoint/src/sdk/pinpoint.dart'
    as pinpoint_sdk;
import 'package:amplify_secure_storage/amplify_secure_storage.dart';

class PinpointClient extends ServiceProviderClient {
  late pinpoint_sdk.PinpointClient _pinpointClient;
  late AmplifySecureStorage _keyValueStore;
  late EndpointClient _endpointClient;
  PinpointPluginConfig? _pinpointConfig;

  @override
  Future<void> init(
      {AmplifyConfig? config,
      required AmplifyAuthProviderRepository authProviderRepo}) async {
    // Parse config values from amplifyconfiguration.json
    if (config == null ||
        config.analytics == null ||
        config.analytics?.awsPlugin == null) {
      throw const AnalyticsException('No Pinpoint plugin config available');
    }

    _pinpointConfig = config.analytics!.awsPlugin!;
    final region = _pinpointConfig?.pinpointAnalytics.region;

    final authProvider = authProviderRepo
        .getAuthProvider(APIAuthorizationType.iam.authProviderToken);
    if (authProvider == null) {
      throw const AnalyticsException(
        'No AWSIamAmplifyAuthProvider available. Is Auth category added and configured?',
      );
    }

    // Initialize Pinpoint Client
    _pinpointClient = pinpoint_sdk.PinpointClient(
      region: region!,
      credentialsProvider: authProvider,
    );

    _keyValueStore = AmplifySecureStorage(
      config: AmplifySecureStorageConfig(
        scope: 'analyticsPinpoint',
      ),
    );
  }

  @override
  Future<void> registerDevice(String deviceToken) async {
    if (_pinpointConfig == null) {
      throw const AnalyticsException(
          'Initialize the client before registering the device');
    }
    final appId = _pinpointConfig?.pinpointAnalytics.appId;

    _endpointClient = await EndpointClient.getInstance(
      appId!,
      _keyValueStore,
      _pinpointClient,
      deviceToken,
    );

    await _endpointClient.updateEndpoint();
  }
}
