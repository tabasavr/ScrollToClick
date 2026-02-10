//
//  ScrollToClick.swift
//  Scroll to Click
//
//  Created by Sergei on 4/2/26.
//

import Cocoa
import SwiftUI

final class ScrollToClick {

    private var eventTap: CFMachPort?

    func start() {

        let mask = CGEventMask(1 << CGEventType.scrollWheel.rawValue)

        eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: mask,
            callback: { _, type, event, refcon in

                // Re-enable if macOS disables us
                if type == .tapDisabledByTimeout || type == .tapDisabledByUserInput {
                    let selfRef = Unmanaged<ScrollToClick>
                        .fromOpaque(refcon!)
                        .takeUnretainedValue()
                    if let tap = selfRef.eventTap {
                        CGEvent.tapEnable(tap: tap, enable: true)
                    }
                    return Unmanaged.passRetained(event)
                }

                guard type == .scrollWheel else {
                    return Unmanaged.passRetained(event)
                }

                // Check trackpad
                let isContinuous = event.getIntegerValueField(
                    .scrollWheelEventIsContinuous
                )
                if isContinuous != 0 && !AppSettings.shared.enableForContinuous {
                    return Unmanaged.passRetained(event)
                }

                let deltaY = event.getIntegerValueField(
                    .scrollWheelEventDeltaAxis1
                )
                if deltaY == 0 {
                    return nil
                }

                let location = event.location

                let action: MouseAction
                if deltaY > 0 {
                    action = AppSettings.shared.actionDown
                } else {
                    action = AppSettings.shared.actionUp
                }

                if action == .none {
                    // don't intercept
                    return Unmanaged.passRetained(event)
                }

                let button: CGMouseButton
                let down: CGEventType
                let up: CGEventType

                if action == .leftClick {
                    button = .left
                    down = .leftMouseDown
                    up = .leftMouseUp
                } else {
                    button = .right
                    down = .rightMouseDown
                    up = .rightMouseUp
                }

                let mouseDown = CGEvent(
                    mouseEventSource: nil,
                    mouseType: down,
                    mouseCursorPosition: location,
                    mouseButton: button
                )

                let mouseUp = CGEvent(
                    mouseEventSource: nil,
                    mouseType: up,
                    mouseCursorPosition: location,
                    mouseButton: button
                )

                mouseDown?.post(tap: .cghidEventTap)
                mouseUp?.post(tap: .cghidEventTap)

                // Block original scroll
                return nil

            },
            userInfo: UnsafeMutableRawPointer(
                Unmanaged.passUnretained(self).toOpaque()
            )
        )

        guard let eventTap else {
            let alert = NSAlert()
            alert.messageText = "Permission Required"
            alert.informativeText = "Failed to create event tap. Please (re-)grant accessibility permissions in System Preferences > Privacy & Security > Accessibility."
            alert.alertStyle = .critical
            alert.addButton(withTitle: "OK")
            alert.runModal()
            
            // Terminate the app after user clicks OK
            NSApplication.shared.terminate(nil)
        
            return
        }

        let source = CFMachPortCreateRunLoopSource(
            kCFAllocatorDefault,
            eventTap,
            0
        )

        CFRunLoopAddSource(
            CFRunLoopGetCurrent(),
            source,
            .commonModes
        )

        CGEvent.tapEnable(tap: eventTap, enable: true)
    }
}
