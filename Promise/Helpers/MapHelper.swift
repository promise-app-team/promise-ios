//
//  MapHelper.swift
//  Promise
//
//  Created by kwh on 2/23/24.
//

import Foundation
import NMapsMap

enum AnimationEffect {
    case linear
    case easeIn
    case easeOut
    case easeInOut
    
    func calculate(_ t: Double) -> Double {
        switch self {
        case .linear:
            return t
        case .easeIn:
            return t * t
        case .easeOut:
            return t * (2 - t)
        case .easeInOut:
            if t < 0.5 {
                return 2 * t * t
            } else {
                return -1 + (4 - 2 * t) * t
            }
        }
    }
}

class MapHelper {
    // MARK: 현재 진행 중인 애니메이션 타이머를 추적하기 위한 변수
    private var animationTimer: Timer?

    // MARK: 애니메이션 스탭(높을 수록 부드러움). but, CPU 사용량 증가
    private var steps = 5000
    
    // MARK: 개선 버전 animationTimer가 있는경우 기존 타이머 무효화 로직 추가됨
    // MARK: overlayLocation의 return 값 NMGLatLng이 있어야함. 즉, marker or overlay가 사전에 미리 map에 등록되어 위치가 있어야함.
    private func animateOverlay(overlayLocation: @escaping () -> NMGLatLng, updateOverlayLocation: @escaping (NMGLatLng) -> Void, to destination: NMGLatLng, duration: TimeInterval, animationEffect: AnimationEffect) {
        animationTimer?.invalidate() // 애니메이션 시작 전 기존 타이머 무효화
        
        let steps = self.steps
        let interval = duration / Double(steps)
        
        let startLat = overlayLocation().lat
        let startLng = overlayLocation().lng
        let endLat = destination.lat
        let endLng = destination.lng
        
        var currentStep = 0
        animationTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] timer in
            currentStep += 1
            let t = animationEffect.calculate(Double(currentStep) / Double(steps))
            let newLat = startLat + (endLat - startLat) * t
            let newLng = startLng + (endLng - startLng) * t
            
            if !newLat.isNaN, !newLng.isNaN {
                updateOverlayLocation(NMGLatLng(lat: newLat, lng: newLng))
            }
            
            if currentStep == steps {
                self?.animationTimer?.invalidate()
                self?.animationTimer = nil
            }
        }
    }
}

extension MapHelper {
    public func animateLocationOverlay(overlay: NMFLocationOverlay, to destination: NMGLatLng, duration: TimeInterval, animationEffect: AnimationEffect = .linear) {
        animateOverlay(overlayLocation: { overlay.location }, updateOverlayLocation: { overlay.location = $0 }, to: destination, duration: duration, animationEffect: animationEffect)
    }
    
    public func animateMarker(marker: NMFMarker, to destination: NMGLatLng, duration: TimeInterval, animationEffect: AnimationEffect = .linear) {
        animateOverlay(overlayLocation: { marker.position }, updateOverlayLocation: { marker.position = $0 }, to: destination, duration: duration, animationEffect: animationEffect)
    }
}

// MARK: 기존 버전
// MARK: overlayLocation의 return 값 NMGLatLng이 있어야함. 즉, marker or overlay가 사전에 미리 map에 등록되어 위치가 있어야함.
//    private func animateOverlay(overlayLocation: @escaping () -> NMGLatLng, updateOverlayLocation: @escaping (NMGLatLng) -> Void, to destination: NMGLatLng, duration: TimeInterval, animationEffect: AnimationEffect) {
//        let steps = self.steps
//        let interval = duration / Double(steps)
//
//        let startLat = overlayLocation().lat
//        let startLng = overlayLocation().lng
//        let endLat = destination.lat
//        let endLng = destination.lng
//
//        var currentStep = 0
//        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
//            currentStep += 1
//            let t = animationEffect.calculate(Double(currentStep) / Double(steps))
//            let newLat = startLat + (endLat - startLat) * t
//            let newLng = startLng + (endLng - startLng) * t
//
//            DispatchQueue.main.async {
//                if !newLat.isNaN, !newLng.isNaN {
//                    updateOverlayLocation(NMGLatLng(lat: newLat, lng: newLng))
//                }
//            }
//
//            if currentStep == steps {
//                timer.invalidate()
//            }
//        }
//    }

