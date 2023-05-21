//
//  AppNavigation.swift
//  XCBuildTimeline
//
//  Created by Mikhail Vospennikov on 20.05.2023.
//

import SwiftUI

struct AppNavigation<Content: View>: View {
    @ViewBuilder var rootContent: () -> Content
    
    var body: some View {
        NavigationStack {
            rootContent()
                .navigationDestination(for: Timeline.self, destination: { timeline in
                    BuildTimeline(timeline: timeline)
                })
        }
    }
}

