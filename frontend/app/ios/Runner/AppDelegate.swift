import Flutter
import GoogleMaps
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private let mapsChannel = "projeto_integrador_jogo/maps"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if let mapsApiKey = Bundle.main.object(forInfoDictionaryKey: "GoogleMapsAPIKey") as? String,
       !mapsApiKey.isEmpty,
       !mapsApiKey.contains("$(") {
      GMSServices.provideAPIKey(mapsApiKey)
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    registerMapsChannel(engineBridge.pluginRegistry)
  }

  private func registerMapsChannel(_ pluginRegistry: FlutterPluginRegistry) {
    guard let registrar = pluginRegistry.registrar(forPlugin: "MapsConfigPlugin") else {
      return
    }

    let channel = FlutterMethodChannel(
      name: mapsChannel,
      binaryMessenger: registrar.messenger()
    )

    channel.setMethodCallHandler { [weak self] call, result in
      switch call.method {
      case "isMapsApiKeyConfigured":
        result(self?.isMapsApiKeyConfigured() ?? false)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func isMapsApiKeyConfigured() -> Bool {
    guard let mapsApiKey = Bundle.main.object(forInfoDictionaryKey: "GoogleMapsAPIKey") as? String else {
      return false
    }

    return !mapsApiKey.isEmpty &&
      !mapsApiKey.contains("$(") &&
      mapsApiKey != "YOUR_IOS_MAPS_API_KEY"
  }
}
