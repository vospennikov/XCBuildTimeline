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
    private var markPositionIdentifier = MarkPositionIdentifier()
    
    var body: some View {
        Chart {
            ForEach(bars) { (bar: BuildTimeline.ChartData.Bar) in
                BarMark(
                    xStart: .value("Start", bar.start),
                    xEnd: .value("Finish", bar.end),
                    y: .value("Target", bar.name),
                    height: .inset(3)
                )
            }
            
            if markPositionIdentifier.rulePositionX > 0 {
                RuleMark(x: .value("Current", markPositionIdentifier.rulePositionX))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [3]))
            }
            
            if let bar = markPositionIdentifier.selectedBar {
                RectangleMark(y: .value("Target", bar.name))
                    .foregroundStyle(.primary.opacity(0.2))
                    .annotation(position: markPositionIdentifier.annotationPosition) {
                        TargetAnnotation(name: bar.name, startTime: bar.start, finishTime: bar.end)
                            .readSize { (newSize: CGSize) in
                                markPositionIdentifier.handleAnnotationSize(newSize)
                            }
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
                        markPositionIdentifier.handleChartsHover(
                            hoverPhase: hoverPhase,
                            geometryProxy: geometryProxy,
                            chartProxy: chartProxy
                        )
                    }
            }
        }
        .frame(height: markPositionIdentifier.chartHeight)
    }
}

extension TimelineChart {
    init(chartData: BuildTimeline.ChartData) {
        self.startBuildTime = chartData.startBuildTime
        self.finishBuildTime = chartData.finishBuildTime
        self.bars = chartData.bars
        self._markPositionIdentifier = State(initialValue: .init(currentBars: chartData.bars))
    }
}

private extension TimelineChart {
    init(
        chartData: BuildTimeline.ChartData,
        rulePositionX: Int = 0,
        selectedBarName: String? = ""
    ) {
        self.startBuildTime = chartData.startBuildTime
        self.finishBuildTime = chartData.finishBuildTime
        self.bars = chartData.bars
        self._markPositionIdentifier = State(
            initialValue: .init(
                currentBars: chartData.bars,
                selectedBar: chartData.bars.first(where: { $0.name == selectedBarName }),
                rulePositionX: rulePositionX
            )
        )
    }
}

struct TimelineChart_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TimelineChart(chartData: .preview, rulePositionX: 14, selectedBarName: "FeatureA1")
            TimelineChart(chartData: .preview, rulePositionX: 18, selectedBarName: "FeatureC2")
            TimelineChart(chartData: .preview, rulePositionX: 41, selectedBarName: "FeatureE")
        }
        .padding(.horizontal)
        .padding(.vertical, 40)
        .previewLayout(.fixed(width: 500, height: 1100))
    }
}
