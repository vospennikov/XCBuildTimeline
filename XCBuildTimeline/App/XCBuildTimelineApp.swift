//
//  XCBuildTimelineApp.swift
//  XCBuildTimeline
//
//  Created by Mikhail Vospennikov on 26.04.2023.
//

import SwiftUI
import AppKit

@main
struct XCBuildTimelineApp: App {
    @Environment(\.isPreview) var isPreview: Bool
    
    var body: some Scene {
        WindowGroup {
            AppNavigation(rootContent: {
                ProjectSettingsView()
            })
            .frame(minWidth: 800, minHeight: 600)
            .onAppear {
                if !isPreview {
                    NSApplication.shared.activate(ignoringOtherApps: true)
                }
            }
            .padding()
        }
        .windowStyle(.titleBar)
        .windowResizability(.contentSize)
    }
}
