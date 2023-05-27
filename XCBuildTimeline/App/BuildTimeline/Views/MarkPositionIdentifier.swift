//
//  MarkPositionIdentifier.swift
//  XCBuildTimeline
//
//  Created by Mikhail Vospennikov on 27.05.2023.
//

import SwiftUI
import Charts

extension TimelineChart {
    struct MarkPositionIdentifier {
        var chartHeight: CGFloat {CGFloat(currentBars.count) * barSize }
        
        var currentBars: [BuildTimeline.ChartData.Bar] = []
        var selectedBar: BuildTimeline.ChartData.Bar?
        var barSize: CGFloat = 24.0
        
        var rulePositionX: Int = 0
        var annotationPosition: AnnotationPosition = .automatic
        
        var hoverLocation: CGPoint?
        
        mutating func handleChartsHover(
            hoverPhase: HoverPhase,
            geometryProxy: GeometryProxy,
            chartProxy: ChartProxy
        ) {
            switch hoverPhase {
            case .active(let newLocation):
                let origin = geometryProxy[chartProxy.plotAreaFrame].origin
                let newHoverLocation = CGPoint(x: newLocation.x - origin.x, y: newLocation.y - origin.y)
                
                let selectedBarName = chartProxy.value(atY: newHoverLocation.y, as: String.self)
                selectedBar = currentBars.first(where: { $0.name == selectedBarName })
                rulePositionX = chartProxy.value(atX: newHoverLocation.x, as: Int.self) ?? 0
                hoverLocation = newHoverLocation
            case .ended:
                hoverLocation = nil
                selectedBar = nil
                rulePositionX = 0
            }
        }
                
        mutating func handleAnnotationSize(_ newSize: CGSize) {
            guard let hoverLocation else { return }
            let topEdgePosition = hoverLocation.y - newSize.height - barSize
            annotationPosition = topEdgePosition > 0 ? .top : .bottom
        }
    }
}
