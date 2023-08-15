// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Common {
    /// Localizable.strings
    ///   Promise
    /// 
    ///   Created by dylan on 2023/07/31.
    internal static let promise = L10n.tr("Localizable", "Common.promise", fallback: "프로미스")
  }
  internal enum Main {
    /// 새 약속 추가
    internal static let addNewPromise = L10n.tr("Localizable", "Main.addNewPromise", fallback: "새 약속 추가")
  }
  internal enum SignIn {
    /// Apple로 로그인
    internal static let appleSignInButtonText = L10n.tr("Localizable", "SignIn.appleSignInButtonText", fallback: "Apple로 로그인")
    /// 구글로 로그인
    internal static let googleSignInButtonText = L10n.tr("Localizable", "SignIn.googleSignInButtonText", fallback: "구글로 로그인")
    /// 카카오로 로그인
    internal static let kakaoSignInButtonText = L10n.tr("Localizable", "SignIn.kakaoSignInButtonText", fallback: "카카오로 로그인")
    /// 만나기 전에 서로의 위치를 공유해 보세요
    internal static let mainDescription = L10n.tr("Localizable", "SignIn.mainDescription", fallback: "만나기 전에 서로의 위치를 공유해 보세요")
    /// 로그인 수단 선택
    internal static let selectSignInMethodText = L10n.tr("Localizable", "SignIn.selectSignInMethodText", fallback: "로그인 수단 선택")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
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
