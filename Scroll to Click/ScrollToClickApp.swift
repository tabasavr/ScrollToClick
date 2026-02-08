//
//  Scroll_to_ClickApp.swift
//  Scroll to Click
//
//  Created by Sergei on 4/2/26.
//

import SwiftUI

@main
struct ScrollToClickApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
