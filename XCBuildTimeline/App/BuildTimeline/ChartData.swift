//
//  InitialData.swift
//  XCBuildTimeline
//
//  Created by Mikhail Vospennikov on 13.05.2023.
//

import Foundation

extension BuildTimeline {
    struct ChartData: Hashable {
        let id = UUID()
        let bars: [Bar]
        let startBuildTime: Int
        let finishBuildTime: Int
        
        struct Bar: Identifiable {
            var id: String { name }
            var name: String
            var start: Int
            var end: Int
        }
        
        static func == (lhs: ChartData, rhs: ChartData) -> Bool {
            lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
}

extension BuildTimeline.ChartData {
    init(bars: [Bar]) {
        self.bars = bars
        self.startBuildTime = bars.min(by: { $0.start < $1.start })?.start ?? 0
        self.finishBuildTime = bars.max(by: { $0.end < $1.end })?.end ?? 0
    }
}

extension BuildTimeline.ChartData {
    static var preview = BuildTimeline.ChartData(
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
}
