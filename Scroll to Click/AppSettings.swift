//
//  Settings.swift
//  Scroll to Click
//
//  Created by Sergei on 10/2/26.
//

import Combine
import SwiftUI

class AppSettings: ObservableObject {
    @AppStorage("actionUp") var actionUp: MouseAction = .rightClick
    @AppStorage("actionDown") var actionDown: MouseAction = .leftClick
    @AppStorage("enableForContinuous") var enableForContinuous: Bool = false

    static let shared = AppSettings()
    private init() {}
}

enum MouseAction: String, CaseIterable {
    case leftClick = "leftClick"
    case rightClick = "rightClick"
    case none = "none"
    
    var displayName: String {
        switch self {
        case .leftClick: return "Left mouse button click"
        case .rightClick: return "Right mouse button click"
        case .none: return "Not intercepted"
        }
    }
}
