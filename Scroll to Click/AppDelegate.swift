//
//  AppDelegate.swift
//  Scroll to Click
//
//  Created by Sergei on 4/2/26.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    private let interceptor = ScrollToClick()

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Start intercepting immediately
        interceptor.start()
    }
}
