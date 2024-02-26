// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Common {
    /// 참여
    internal static let attend = L10n.tr("Localizable", "Common.attend", fallback: "참여")
    /// 참여자
    internal static let attendees = L10n.tr("Localizable", "Common.attendees", fallback: "참여자")
    /// 취소
    internal static let cancel = L10n.tr("Localizable", "Common.cancel", fallback: "취소")
    /// 확인
    internal static let confirm = L10n.tr("Localizable", "Common.confirm", fallback: "확인")
    /// 생성자
    internal static let host = L10n.tr("Localizable", "Common.host", fallback: "생성자")
    /// 시간
    internal static let hour = L10n.tr("Localizable", "Common.hour", fallback: "시간")
    /// km
    internal static let km = L10n.tr("Localizable", "Common.km", fallback: "km")
    /// m
    internal static let m = L10n.tr("Localizable", "Common.m", fallback: "m")
    /// 분
    internal static let minute = L10n.tr("Localizable", "Common.minute", fallback: "분")
    /// 장소
    internal static let place = L10n.tr("Localizable", "Common.place", fallback: "장소")
    /// Localizable.strings
    ///   Promise
    /// 
    ///   Created by dylan on 2023/07/31.
    internal static let promise = L10n.tr("Localizable", "Common.promise", fallback: "프로미스")
    /// 거절
    internal static let refuse = L10n.tr("Localizable", "Common.refuse", fallback: "거절")
    internal enum MoreMenu {
      /// 약속 위임
      internal static let delegatePromise = L10n.tr("Localizable", "Common.MoreMenu.delegatePromise", fallback: "약속 위임")
      /// 약속 수정
      internal static let editPromise = L10n.tr("Localizable", "Common.MoreMenu.editPromise", fallback: "약속 수정")
      /// 약속 나가기
      internal static let leavePromise = L10n.tr("Localizable", "Common.MoreMenu.leavePromise", fallback: "약속 나가기")
    }
  }
  internal enum CompletedCreatePromise {
    /// 약속 생성 완료
    internal static let headerTitle = L10n.tr("Localizable", "CompletedCreatePromise.headerTitle", fallback: "약속 생성 완료")
    /// 생성된 약속은 메인화면과 약속 상세페이지에 있는
    /// 공유 아이콘으로 초대할 수 있어요
    internal static let mainDescription = L10n.tr("Localizable", "CompletedCreatePromise.mainDescription", fallback: "생성된 약속은 메인화면과 약속 상세페이지에 있는\n공유 아이콘으로 초대할 수 있어요")
    /// 약속이 생성되었어요
    /// 이제 참여자를 초대해 볼까요?
    internal static let mainTitle = L10n.tr("Localizable", "CompletedCreatePromise.mainTitle", fallback: "약속이 생성되었어요\n이제 참여자를 초대해 볼까요?")
    /// 약속 공유
    internal static let shareButtonText = L10n.tr("Localizable", "CompletedCreatePromise.shareButtonText", fallback: "약속 공유")
    internal enum MainDescription {
      /// 메인화면과 약속 상세페이지에 있는
      /// 공유 아이콘
      internal static let highlight = L10n.tr("Localizable", "CompletedCreatePromise.MainDescription.highlight", fallback: "메인화면과 약속 상세페이지에 있는\n공유 아이콘")
    }
  }
  internal enum CreatePromise {
    /// 약속 생성
    internal static let createPromiseButtonTitle = L10n.tr("Localizable", "CreatePromise.createPromiseButtonTitle", fallback: "약속 생성")
    /// 약속 시간
    internal static let formDateLabel = L10n.tr("Localizable", "CreatePromise.formDateLabel", fallback: "약속 시간")
    /// 약속 장소
    internal static let formPlaceLabel = L10n.tr("Localizable", "CreatePromise.formPlaceLabel", fallback: "약속 장소")
    /// 위치 공유 종료 시간
    internal static let formShareLocationEndTimeLabel = L10n.tr("Localizable", "CreatePromise.formShareLocationEndTimeLabel", fallback: "위치 공유 종료 시간")
    /// 위치 공유 시작 시간
    internal static let formShareLocationStartTimeLabel = L10n.tr("Localizable", "CreatePromise.formShareLocationStartTimeLabel", fallback: "위치 공유 시작 시간")
    /// 약속 테마
    internal static let formThemeLabel = L10n.tr("Localizable", "CreatePromise.formThemeLabel", fallback: "약속 테마")
    /// 약속 제목
    internal static let formTitleLabel = L10n.tr("Localizable", "CreatePromise.formTitleLabel", fallback: "약속 제목")
    /// 새 약속 추가
    internal static let headerTitle = L10n.tr("Localizable", "CreatePromise.headerTitle", fallback: "새 약속 추가")
    /// 중간 장소는 어떻게 설정되나요?
    internal static let promiseMiddlePlaceGuidance = L10n.tr("Localizable", "CreatePromise.promiseMiddlePlaceGuidance", fallback: "중간 장소는 어떻게 설정되나요?")
    /// 도로명, 지번, 건물명 검색
    internal static let promisePlaceInputPlaceholder = L10n.tr("Localizable", "CreatePromise.promisePlaceInputPlaceholder", fallback: "도로명, 지번, 건물명 검색")
    /// ex) 독서모임 1회차
    internal static let promiseTitleInputPlaceholder = L10n.tr("Localizable", "CreatePromise.promiseTitleInputPlaceholder", fallback: "ex) 독서모임 1회차")
    internal enum PlaceType {
      /// 장소 지정
      internal static let designation = L10n.tr("Localizable", "CreatePromise.PlaceType.designation", fallback: "장소 지정")
      /// 중간 장소
      internal static let middle = L10n.tr("Localizable", "CreatePromise.PlaceType.middle", fallback: "중간 장소")
    }
    internal enum PromiseMiddlePlaceGuidance {
      /// 두명 이상의 약속 참여자가 출발지를 등록하면
      /// 프로미스가 중간장소를 추천해 드려요.
      /// 약속 시간 전까지 꼭 출발지를 등록해 주세요!
      internal static let popupDescription = L10n.tr("Localizable", "CreatePromise.PromiseMiddlePlaceGuidance.popupDescription", fallback: "두명 이상의 약속 참여자가 출발지를 등록하면\n프로미스가 중간장소를 추천해 드려요.\n약속 시간 전까지 꼭 출발지를 등록해 주세요!")
      internal enum PopupDescription {
        /// 약속 시간 전까지 꼭 출발지를 등록해 주세요!
        internal static let highlight = L10n.tr("Localizable", "CreatePromise.PromiseMiddlePlaceGuidance.PopupDescription.highlight", fallback: "약속 시간 전까지 꼭 출발지를 등록해 주세요!")
      }
    }
    internal enum ShareLocationEnd {
      /// 후까지
      internal static let itemSuffix = L10n.tr("Localizable", "CreatePromise.ShareLocationEnd.itemSuffix", fallback: "후까지")
      /// 약속 날짜 자정까지
      internal static let max = L10n.tr("Localizable", "CreatePromise.ShareLocationEnd.max", fallback: "약속 날짜 자정까지")
      /// 위치 공유 종료 시간 선택
      internal static let selectionLabel = L10n.tr("Localizable", "CreatePromise.ShareLocationEnd.selectionLabel", fallback: "위치 공유 종료 시간 선택")
    }
    internal enum ShareLocationStartType {
      /// 거리 기준
      internal static let basedOnDistance = L10n.tr("Localizable", "CreatePromise.ShareLocationStartType.basedOnDistance", fallback: "거리 기준")
      /// 시간 기준
      internal static let basedOnTime = L10n.tr("Localizable", "CreatePromise.ShareLocationStartType.basedOnTime", fallback: "시간 기준")
      internal enum BaseOnDistance {
        /// 약속 장소로부터
        internal static let itemPrefix = L10n.tr("Localizable", "CreatePromise.ShareLocationStartType.BaseOnDistance.itemPrefix", fallback: "약속 장소로부터")
        /// 위치 공유 거리 선택
        internal static let selectionLabel = L10n.tr("Localizable", "CreatePromise.ShareLocationStartType.BaseOnDistance.selectionLabel", fallback: "위치 공유 거리 선택")
      }
      internal enum BasedOnTime {
        /// 약속 시간
        internal static let itemPrefix = L10n.tr("Localizable", "CreatePromise.ShareLocationStartType.BasedOnTime.itemPrefix", fallback: "약속 시간")
        /// 전부터
        internal static let itemSuffix = L10n.tr("Localizable", "CreatePromise.ShareLocationStartType.BasedOnTime.itemSuffix", fallback: "전부터")
        /// 위치 공유 시작 시간 선택
        internal static let selectionLabel = L10n.tr("Localizable", "CreatePromise.ShareLocationStartType.BasedOnTime.selectionLabel", fallback: "위치 공유 시작 시간 선택")
      }
    }
  }
  internal enum GuideAttendee {
    /// 약속하러 가기
    internal static let attend = L10n.tr("Localizable", "GuideAttendee.attend", fallback: "약속하러 가기")
    /// 바로 참여하기
    internal static let directAttend = L10n.tr("Localizable", "GuideAttendee.directAttend", fallback: "바로 참여하기")
    /// GPS 공유로
    /// 서로의 위치를 알 수 있어요
    internal static let title1 = L10n.tr("Localizable", "GuideAttendee.title1", fallback: "GPS 공유로\n서로의 위치를 알 수 있어요")
    /// 출발지와 경로를 기반으로
    /// 중간위치를 알 수 있어요
    internal static let title2 = L10n.tr("Localizable", "GuideAttendee.title2", fallback: "출발지와 경로를 기반으로\n중간위치를 알 수 있어요")
    /// 안전하게 내 위치를 공유해요
    internal static let title3 = L10n.tr("Localizable", "GuideAttendee.title3", fallback: "안전하게 내 위치를 공유해요")
    internal enum Title1 {
      /// •  약속한 사람이 어디까지 왔는지!
      internal static let bulletPoint1 = L10n.tr("Localizable", "GuideAttendee.Title1.bulletPoint1", fallback: "•  약속한 사람이 어디까지 왔는지!")
      /// •  내가 약속장소에 언제 도착하는지!
      internal static let bulletPoint2 = L10n.tr("Localizable", "GuideAttendee.Title1.bulletPoint2", fallback: "•  내가 약속장소에 언제 도착하는지!")
    }
    internal enum Title2 {
      /// •  어디서 만날지 고민이라면 중간에서 만나요
      internal static let bulletPoint1 = L10n.tr("Localizable", "GuideAttendee.Title2.bulletPoint1", fallback: "•  어디서 만날지 고민이라면 중간에서 만나요")
      /// •  중간위치 주변 장소를 추천 받아요!
      internal static let bulletPoint2 = L10n.tr("Localizable", "GuideAttendee.Title2.bulletPoint2", fallback: "•  중간위치 주변 장소를 추천 받아요!")
    }
    internal enum Title3 {
      /// •  GPS 정보는 어디에도 저장하지 않아요!
      internal static let bulletPoint1 = L10n.tr("Localizable", "GuideAttendee.Title3.bulletPoint1", fallback: "•  GPS 정보는 어디에도 저장하지 않아요!")
      /// •  위치를 공유할 시점을 정할 수 있어요!
      internal static let bulletPoint2 = L10n.tr("Localizable", "GuideAttendee.Title3.bulletPoint2", fallback: "•  위치를 공유할 시점을 정할 수 있어요!")
      /// •  모두가 만났으면 위치 공유는 종료돼요!
      internal static let bulletPoint3 = L10n.tr("Localizable", "GuideAttendee.Title3.bulletPoint3", fallback: "•  모두가 만났으면 위치 공유는 종료돼요!")
    }
  }
  internal enum InvitationPopUp {
    /// 참여자들의 중간장소로 지정됩니다
    internal static let middlePlaceWarning = L10n.tr("Localizable", "InvitationPopUp.middlePlaceWarning", fallback: "참여자들의 중간장소로 지정됩니다")
    /// 출발지를 등록해 주세요
    internal static let startLocationPlaceholder = L10n.tr("Localizable", "InvitationPopUp.startLocationPlaceholder", fallback: "출발지를 등록해 주세요")
    internal enum IsFailedAttendPromise {
      /// 서버 문제로 약속 참여에 실패했습니다.
      /// 관리자에게 문의해주세요.
      internal static let description = L10n.tr("Localizable", "InvitationPopUp.IsFailedAttendPromise.description", fallback: "서버 문제로 약속 참여에 실패했습니다.\n관리자에게 문의해주세요.")
      /// 약속에 참여할 수 없습니다
      internal static let title = L10n.tr("Localizable", "InvitationPopUp.IsFailedAttendPromise.title", fallback: "약속에 참여할 수 없습니다")
    }
    internal enum IsNotAbleToPromise {
      /// 약속이 존재하지 않거나 약속 정보를 불러오는데 실패했습니다.
      internal static let description = L10n.tr("Localizable", "InvitationPopUp.IsNotAbleToPromise.description", fallback: "약속이 존재하지 않거나 약속 정보를 불러오는데 실패했습니다.")
      /// 참여할 수 없는 약속입니다
      internal static let title = L10n.tr("Localizable", "InvitationPopUp.IsNotAbleToPromise.title", fallback: "참여할 수 없는 약속입니다")
    }
    internal enum Toast {
      /// 약속에 참여했어요!
      internal static let successAttendPromise = L10n.tr("Localizable", "InvitationPopUp.Toast.successAttendPromise", fallback: "약속에 참여했어요!")
    }
  }
  internal enum Main {
    /// 새 약속 추가
    internal static let addNewPromise = L10n.tr("Localizable", "Main.addNewPromise", fallback: "새 약속 추가")
    /// 초대받은 약속이 있다면
    /// 공유된 링크를 다시 눌러주세요
    internal static let emptyPromisesDescription = L10n.tr("Localizable", "Main.emptyPromisesDescription", fallback: "초대받은 약속이 있다면\n공유된 링크를 다시 눌러주세요")
    /// 초대받은 약속이 있나요?
    internal static let emptyPromisesTitle = L10n.tr("Localizable", "Main.emptyPromisesTitle", fallback: "초대받은 약속이 있나요?")
    internal enum Probee {
      internal enum Guidance {
        /// 공유 아이콘으로 약속에 초대할 수 있어요!
        internal static let share = L10n.tr("Localizable", "Main.Probee.Guidance.share", fallback: "공유 아이콘으로 약속에 초대할 수 있어요!")
        internal enum Share {
          /// 공유 아이콘
          internal static let highlight = L10n.tr("Localizable", "Main.Probee.Guidance.Share.highlight", fallback: "공유 아이콘")
        }
      }
    }
    internal enum PromiseList {
      /// 참여자
      internal static let attendeesLabel = L10n.tr("Localizable", "Main.PromiseList.attendeesLabel", fallback: "참여자")
      /// 생성자
      internal static let hostLabel = L10n.tr("Localizable", "Main.PromiseList.hostLabel", fallback: "생성자")
      /// 장소
      internal static let placeLabel = L10n.tr("Localizable", "Main.PromiseList.placeLabel", fallback: "장소")
      internal enum DynamicPlace {
        /// 두 명 이상 출발지를 설정해주세요
        internal static let placeholder = L10n.tr("Localizable", "Main.PromiseList.DynamicPlace.placeholder", fallback: "두 명 이상 출발지를 설정해주세요")
        /// 중간 장소를 확인해주세요
        internal static let requestConfirm = L10n.tr("Localizable", "Main.PromiseList.DynamicPlace.requestConfirm", fallback: "중간 장소를 확인해주세요")
      }
    }
    internal enum SortPromiseList {
      /// 약속시간 늦은순
      internal static let dateTimeLateOrder = L10n.tr("Localizable", "Main.SortPromiseList.dateTimeLateOrder", fallback: "약속시간 늦은순")
      /// 약속시간 빠른순
      internal static let dateTimeQuickOrder = L10n.tr("Localizable", "Main.SortPromiseList.dateTimeQuickOrder", fallback: "약속시간 빠른순")
      /// 정렬 선택
      internal static let selectOrder = L10n.tr("Localizable", "Main.SortPromiseList.selectOrder", fallback: "정렬 선택")
    }
  }
  internal enum PromiseStatusWithAllAttendeesView {
    internal enum Header {
      /// 약속 상세
      internal static let title = L10n.tr("Localizable", "PromiseStatusWithAllAttendeesView.Header.title", fallback: "약속 상세")
    }
    internal enum More {
      internal enum LeavePromise {
        /// 약속 나가기 실패
        internal static let failure = L10n.tr("Localizable", "PromiseStatusWithAllAttendeesView.More.LeavePromise.failure", fallback: "약속 나가기 실패")
        /// 약속에서 나갔어요
        internal static let success = L10n.tr("Localizable", "PromiseStatusWithAllAttendeesView.More.LeavePromise.success", fallback: "약속에서 나갔어요")
      }
    }
  }
  internal enum PromiseStatusWithUserView {
    /// 약속시간 전까지 꼭 출발지를 설정해주세요
    internal static let departureLocationPlaceholder = L10n.tr("Localizable", "PromiseStatusWithUserView.departureLocationPlaceholder", fallback: "약속시간 전까지 꼭 출발지를 설정해주세요")
    internal enum Label {
      /// 내 출발지
      internal static let departureLocation = L10n.tr("Localizable", "PromiseStatusWithUserView.Label.departureLocation", fallback: "내 출발지")
      /// 내 위치공유 상태
      internal static let userSharingState = L10n.tr("Localizable", "PromiseStatusWithUserView.Label.userSharingState", fallback: "내 위치공유 상태")
      /// 내 현재 상태
      internal static let userStatus = L10n.tr("Localizable", "PromiseStatusWithUserView.Label.userStatus", fallback: "내 현재 상태")
    }
    internal enum Tag {
      /// 출발 전
      internal static let notStart = L10n.tr("Localizable", "PromiseStatusWithUserView.Tag.notStart", fallback: "출발 전")
      /// 내 위치공유가 꺼져있어요
      internal static let sharingOff = L10n.tr("Localizable", "PromiseStatusWithUserView.Tag.sharingOff", fallback: "내 위치공유가 꺼져있어요")
      /// 내 위치공유가 켜져있어요
      internal static let sharingOn = L10n.tr("Localizable", "PromiseStatusWithUserView.Tag.sharingOn", fallback: "내 위치공유가 켜져있어요")
    }
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
  internal enum TaggedNotification {
    /// 띵동! 약속에 초대 받았어요
    internal static let invitedToPromise = L10n.tr("Localizable", "TaggedNotification.invitedToPromise", fallback: "띵동! 약속에 초대 받았어요")
    /// 모두 출발지를 등록해야 중간장소를 정해드릴 수 있어요
    internal static let middlePlaceWarning = L10n.tr("Localizable", "TaggedNotification.middlePlaceWarning", fallback: "모두 출발지를 등록해야 중간장소를 정해드릴 수 있어요")
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
