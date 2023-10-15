// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - JSON Files

// swiftlint:disable identifier_name line_length type_body_length
internal enum JSONFiles {
  internal enum Logo {
    private static let _document = JSONDocument(path: "logo.json")
    internal static let assets: [[String: Any]] = _document["assets"]
    internal static let ddd: Int = _document["ddd"]
    internal static let fr: Double = _document["fr"]
    internal static let h: Int = _document["h"]
    internal static let ip: Int = _document["ip"]
    internal static let layers: [[String: Any]] = _document["layers"]
    internal static let markers: [String] = _document["markers"]
    internal static let meta: [String: Any] = _document["meta"]
    internal static let nm: String = _document["nm"]
    internal static let op: Double = _document["op"]
    internal static let v: String = _document["v"]
    internal static let w: Int = _document["w"]
  }
  internal enum Map {
    private static let _document = JSONDocument(path: "map.json")
    internal static let complete: Bool = _document["__complete"]
    internal static let assets: [String] = _document["assets"]
    internal static let ddd: Int = _document["ddd"]
    internal static let fr: Int = _document["fr"]
    internal static let h: Int = _document["h"]
    internal static let ip: Int = _document["ip"]
    internal static let layers: [[String: Any]] = _document["layers"]
    internal static let markers: [String] = _document["markers"]
    internal static let nm: String = _document["nm"]
    internal static let op: Int = _document["op"]
    internal static let v: String = _document["v"]
    internal static let w: Int = _document["w"]
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

private func objectFromJSON<T>(at path: String) -> T {
  guard let url = BundleToken.bundle.url(forResource: path, withExtension: nil),
    let json = try? JSONSerialization.jsonObject(with: Data(contentsOf: url), options: []),
    let result = json as? T else {
    fatalError("Unable to load JSON at path: \(path)")
  }
  return result
}

private struct JSONDocument {
  let data: [String: Any]

  init(path: String) {
    self.data = objectFromJSON(at: path)
  }

  subscript<T>(key: String) -> T {
    guard let result = data[key] as? T else {
      fatalError("Property '\(key)' is not of type \(T.self)")
    }
    return result
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
