//
//  SettingsView.swift
//  Scroll to Click
//
//  Created by Sergei on 10/2/26.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject private var settings = AppSettings.shared

    var body: some View {
        Form {
            Picker("Scroll up action:", selection: $settings.actionUp) {
                ForEach(MouseAction.allCases, id: \.self) { action in
                    Text(action.displayName).tag(action)
                }
            }
            Picker("Scroll down action:", selection: $settings.actionDown) {
                ForEach(MouseAction.allCases, id: \.self) { action in
                    Text(action.displayName).tag(action)
                }
            }
            Toggle("Enable for continuous scroll (trackpad)", isOn: $settings.enableForContinuous)
        }
        .padding(20)
    }
}
