import Flutter
import UIKit

public class SeasonalAppIconPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "seasonal_app_icon", binaryMessenger: registrar.messenger())
    let instance = SeasonalAppIconPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "setIcon":
      handleSetIcon(call: call, result: result)
    case "getCurrentIcon":
      handleGetCurrentIcon(result: result)
    case "supportsAlternateIcons":
      handleSupportsAlternateIcons(result: result)
    case "getAvailableIcons":
      handleGetAvailableIcons(result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func handleSetIcon(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard UIApplication.shared.supportsAlternateIcons else {
      result(["success": false, "error": "Alternate icons are not supported on this device"])
      return
    }

    guard let args = call.arguments as? [String: Any] else {
      result(["success": false, "error": "Invalid arguments"])
      return
    }

    let iconName = args["iconName"] as? String

    UIApplication.shared.setAlternateIconName(iconName) { error in
      if let error = error {
        result(["success": false, "error": error.localizedDescription])
      } else {
        result(["success": true, "iconName": iconName as Any])
      }
    }
  }

  private func handleGetCurrentIcon(result: @escaping FlutterResult) {
    if UIApplication.shared.supportsAlternateIcons {
      result(UIApplication.shared.alternateIconName)
    } else {
      result(nil)
    }
  }

  private func handleSupportsAlternateIcons(result: @escaping FlutterResult) {
    result(UIApplication.shared.supportsAlternateIcons)
  }

  private func handleGetAvailableIcons(result: @escaping FlutterResult) {
    guard let icons = Bundle.main.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any],
          let alternateIcons = icons["CFBundleAlternateIcons"] as? [String: Any] else {
      result([String]())
      return
    }
    result(Array(alternateIcons.keys))
  }
}
