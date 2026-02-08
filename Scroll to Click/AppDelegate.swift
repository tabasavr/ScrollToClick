//
//  AppDelegate.swift
//  Scroll to Click
//
//  Created by Sergei on 4/2/26.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    private var statusItem: NSStatusItem!
    private let interceptor = ScrollToClick()

    func applicationDidFinishLaunching(_ notification: Notification) {

        // Start intercepting immediately
        interceptor.start()

        // Menu bar item
        statusItem = NSStatusBar.system.statusItem(
            withLength: NSStatusItem.squareLength
        )

        if let button = statusItem.button {
            let image = NSImage(
                systemSymbolName: "computermouse",
                accessibilityDescription: "Scroll to Click"
            )
            image?.isTemplate = true
            button.image = image
        }

        let menu = NSMenu()
        menu.addItem(
            NSMenuItem(
                title: "Quit",
                action: #selector(quit),
                keyEquivalent: "q"
            )
        )

        statusItem.menu = menu
    }

    @objc private func quit() {
        NSApp.terminate(nil)
    }
}
