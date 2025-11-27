//
//  FlashMode.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/11/03.
//
import AVFoundation

// カメラのモードの定義
enum FlashMode {
    case on, off, auto
    
    var iconName: String {
        switch self {
        case .on: return "bolt.fill"
        case .off: return "bolt.slash.fill"
        case .auto: return "bolt.badge.automatic.fill"
        }
    }
    
    // 次のモードに切り替えるメソッド
    mutating func toggle() {
        switch self {
        case .auto: self = .on
        case .on: self = .off
        case .off: self = .auto
        }
    }
    
    // AVCapturePhotoSettings に渡す FlashMode
    var avFlashMode: AVCaptureDevice.FlashMode {
        switch self {
        case .on: return .on
        case .off: return .off
        case .auto: return .auto
        }
    }
}
