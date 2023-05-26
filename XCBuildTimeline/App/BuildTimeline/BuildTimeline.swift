//
//  BuildTimeline.swift
//  XCBuildTimeline
//
//  Created by Mikhail Vospennikov on 28.04.2023.
//

import SwiftUI
import Charts

struct BuildTimeline: View {
    var timeline: Timeline
    
    @Environment(\.displayScale)
    private var scale
    
    @State
    private var selectedTarget: String?
    @State
    private var ruleTarget: Int?
    
    var body: some View {
        ScrollView {
            chart
                .padding()
                .toolbar {
                    Button("Share", action: { shareTimelineImage() })
                }
        }
    }
    
    private var chart: some View {
        Chart {
            ForEach(timeline.bars) { bar in
                BarMark(
                    xStart: .value("Start", bar.start),
                    xEnd: .value("Finish", bar.end),
                    y: .value("Target", bar.name),
                    height: .fixed(16)
                )
            }
            
            if let ruleTarget {
                RuleMark(x: .value("Current", ruleTarget))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [3]))
            }
            
            if let selectedTarget,
               let selectedBar = timeline.bars.first(where: { bar in bar.name == selectedTarget}) {
                RectangleMark(y: .value("Target", selectedTarget))
                    .foregroundStyle(.primary.opacity(0.2))
                    .annotation(position: .automatic, alignment: .center, spacing: 10) {
                        TargetAnnotation(
                            name: selectedBar.name,
                            startTime: selectedBar.start,
                            finishTime: selectedBar.end
                        )
                    }
            }
        }
        .chartYAxis {
            AxisMarks(preset: .extended, position: .leading) { (axisValue: AxisValue) in
                AxisGridLine(centered: false)
                AxisTick(centered: false, length: .longestLabel, stroke: nil)
                AxisValueLabel()
            }
        }
        .chartXAxis {
            AxisMarks(
                preset: .aligned,
                position: .bottom,
                values: .automatic(
                    minimumStride: 1,
                    desiredCount: 10,
                    roundLowerBound: false,
                    roundUpperBound: false
                )
            ) { (axisValue: AxisValue) in
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
            }
        }
        .chartXScale(domain: timeline.startBuildTime...timeline.finishBuildTime)
        .chartOverlay { (chartProxy: ChartProxy) in
            GeometryReader { (geometryProxy: GeometryProxy) in
                Color.clear
                    .onContinuousHover { (hoverPhase: HoverPhase) in
                        switch hoverPhase {
                        case .active(let hoverLocation):
                            let origin = geometryProxy[chartProxy.plotAreaFrame].origin
                            let location = CGPoint(
                                x: hoverLocation.x - origin.x,
                                y: hoverLocation.y - origin.y
                            )
                            selectedTarget = chartProxy.value(atY: location.y, as: String.self)
                            ruleTarget = chartProxy.value(atX: location.x, as: Int.self)
                        case .ended:
                            selectedTarget = nil
                            ruleTarget = nil
                        }
                    }
            }
        }
        .frame(height: CGFloat(timeline.bars.count) * 24.0)
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
            let modifiedImage = chart
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

private extension BuildTimeline {
    init(timeline: Timeline, selectedTarget: String? = nil, ruleTarget: Int? = nil) {
        self.timeline = timeline
        self._selectedTarget = State(initialValue: selectedTarget)
        self._ruleTarget = State(initialValue: ruleTarget)
    }
}

struct BuildTimeline_Previews: PreviewProvider {
    static var previews: some View {
        let timeline = Timeline(
            bars: [
                .init(name: "FeatureA1", start: 0, end: 14),
                .init(name: "FeatureA2", start: 0, end: 16),
                .init(name: "FeatureA3", start: 0, end: 13),
                .init(name: "VeryLongFeatureName", start: 4, end: 20),
                .init(name: "FeatureB2", start: 4, end: 18),
                .init(name: "Short", start: 18, end: 20),
                .init(name: "FeatureC2", start: 18, end: 24),
                .init(name: "FeatureC3", start: 20, end: 22),
                .init(name: "FeatureC4", start: 22, end: 24),
                .init(name: "FeatureD1", start: 24, end: 36),
                .init(name: "FeatureD2", start: 24, end: 39),
                .init(name: "FeatureC", start: 39, end: 41),
                .init(name: "FeatureE", start: 41, end: 48),
            ]
        )
        
        VStack {
            BuildTimeline(timeline: timeline, selectedTarget: "FeatureA1", ruleTarget: 14)
            BuildTimeline(timeline: timeline, selectedTarget: "FeatureC2", ruleTarget: 18)
            BuildTimeline(timeline: timeline, selectedTarget: "FeatureE", ruleTarget: 41)
        }
        .padding(.horizontal)
        .padding(.vertical, 40)
        .previewLayout(.fixed(width: 500, height: 1100))
    }
}
