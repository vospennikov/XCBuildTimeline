//
//  TimelineChart.swift
//  XCBuildTimeline
//
//  Created by Mikhail Vospennikov on 26.05.2023.
//

import SwiftUI
import Charts

struct TimelineChart: View {
    var startBuildTime: Int
    var finishBuildTime: Int
    var bars: [BuildTimeline.ChartData.Bar]
    
    @State
    private var ruleMarkLocationX: Int?
    
    @State
    private var selectedBarName: String?
    
    var body: some View {
        Chart {
            ForEach(bars) { (bar: BuildTimeline.ChartData.Bar) in
                BarMark(
                    xStart: .value("Start", bar.start),
                    xEnd: .value("Finish", bar.end),
                    y: .value("Target", bar.name),
                    height: .fixed(16)
                )
            }
            
            if let ruleMarkLocationX {
                RuleMark(x: .value("Current", ruleMarkLocationX))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [3]))
            }
            
            if let selectedBarName,
               let selectedBar = bars.first(where: { bar in bar.name == selectedBarName}) {
                RectangleMark(y: .value("Target", selectedBarName))
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
        .chartXScale(domain: startBuildTime...finishBuildTime)
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
                            selectedBarName = chartProxy.value(atY: location.y, as: String.self)
                            ruleMarkLocationX = chartProxy.value(atX: location.x, as: Int.self)
                        case .ended:
                            selectedBarName = nil
                            ruleMarkLocationX = nil
                        }
                    }
            }
        }
        .frame(height: CGFloat(bars.count) * 24.0)
    }
}

extension TimelineChart {
    init(chartData: BuildTimeline.ChartData) {
        self.startBuildTime = chartData.startBuildTime
        self.finishBuildTime = chartData.finishBuildTime
        self.bars = chartData.bars
    }
}

private extension TimelineChart {
    init(
        chartData: BuildTimeline.ChartData,
        ruleMarkLocationX: Int? = 0,
        selectedBarName: String? = ""
    ) {
        self.startBuildTime = chartData.startBuildTime
        self.finishBuildTime = chartData.finishBuildTime
        self.bars = chartData.bars
        self._ruleMarkLocationX = State(initialValue: ruleMarkLocationX)
        self._selectedBarName = State(initialValue: selectedBarName)
    }
}

struct TimelineChart_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TimelineChart(chartData: .preview, ruleMarkLocationX: 14, selectedBarName: "FeatureA1")
            TimelineChart(chartData: .preview, ruleMarkLocationX: 18, selectedBarName: "FeatureC2")
            TimelineChart(chartData: .preview, ruleMarkLocationX: 41, selectedBarName: "FeatureE")
        }
        .padding(.horizontal)
        .padding(.vertical, 40)
        .previewLayout(.fixed(width: 500, height: 1100))
    }
}
