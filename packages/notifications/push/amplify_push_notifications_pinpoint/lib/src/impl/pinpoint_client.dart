import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_push_notifications_pinpoint/src/flutter_provider_interfaces/device_context_info_provider.dart';
import 'package:amplify_push_notifications_pinpoint/src/impl/device_context_info_provider/flutter_device_context_info_provider.dart';
import 'package:amplify_push_notifications_pinpoint/src/impl/endpoint_client.dart';
import 'package:amplify_push_notifications_pinpoint/src/impl/event_client/event_client.dart';
import 'package:amplify_push_notifications_pinpoint/src/impl/event_creator/event_creator.dart';
import 'package:amplify_push_notifications_pinpoint/src/sdk/pinpoint.dart'
    as pinpoint_sdk;
import 'package:amplify_secure_storage/amplify_secure_storage.dart';

class PinpointClient extends ServiceProviderClient {
  late pinpoint_sdk.PinpointClient _pinpointClient;
  late AmplifySecureStorage _keyValueStore;
  late EndpointClient _endpointClient;
  PinpointPluginConfig? _pinpointConfig;
  EventClient? _eventClient;
  late EventCreator _eventCreator;
  late DeviceContextInfoProvider? _deviceContextInfoProvider;

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

    _deviceContextInfoProvider = const FlutterDeviceContextInfoProvider();
    final deviceContextInfo =
        await _deviceContextInfoProvider?.getDeviceInfoDetails();

    // Initialize EventCreator
    _eventCreator = EventCreator.getInstance(
      deviceContextInfo: deviceContextInfo,
    );

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

    // Initialize EventClient
    _eventClient = EventClient.getInstance(
      appId: appId,
      fixedEndpointId: _endpointClient.fixedEndpointId,
      endpointClient: _endpointClient,
      pinpointClient: _pinpointClient,
    );

    await _endpointClient.updateEndpoint();
  }

  @override
  Future<void> recordNotificationEvent({
    required AnalyticsEvent event,
  }) async {
    if (_eventClient == null) {
      throw const AnalyticsException(
          'Call the init and registerDevice APIs before recoring an event');
    }
    final pinpointEvent = _eventCreator.createPinpointEvent(
      event.name,
      event,
    );
    await _eventClient!.recordEvent(pinpointEvent);
  }
}
