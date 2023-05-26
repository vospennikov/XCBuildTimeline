//
//  BuildTimeline.swift
//  XCBuildTimeline
//
//  Created by Mikhail Vospennikov on 28.04.2023.
//

import SwiftUI
import Charts

struct BuildTimeline: View {
    var timeline: ChartData
    
    @Environment(\.displayScale)
    private var scale
    
    var body: some View {
        ScrollView {
            timelineChart
                .padding()
                .toolbar {
                    Button("Share", action: { shareTimelineImage() })
                }
        }
    }
    
    @ViewBuilder
    private var timelineChart: some View {
        TimelineChart(chartData: timeline)
    }
    
    @MainActor
    private func shareTimelineImage() {
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.png]
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        savePanel.title = "Save"
        
        let response = savePanel.runModal()
        if response == .OK {
            let modifiedImage = timelineChart
                .background { Color.white }
                .frame(width: 2000)
            
            let renderer = ImageRenderer(content: modifiedImage)
            renderer.scale = scale
            if let image = renderer.cgImage, let saveURL = savePanel.url {
                let imageRepresentable = NSBitmapImageRep(cgImage: image)
                let pngData = imageRepresentable.representation(using: .png, properties: [:])
                do {
                    try pngData?.write(to: saveURL)
                } catch {}
            }
        }
    }
}

struct BuildTimeline_Previews: PreviewProvider {
    static var previews: some View {
        BuildTimeline(timeline: .preview)
    }
}
