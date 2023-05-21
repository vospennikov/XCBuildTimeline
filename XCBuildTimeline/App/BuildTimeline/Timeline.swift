//
//  Timeline.swift
//  XCBuildTimeline
//
//  Created by Mikhail Vospennikov on 13.05.2023.
//

import Foundation

struct Timeline: Hashable {
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
    
    static func == (lhs: Timeline, rhs: Timeline) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Timeline {
    init(bars: [Bar]) {
        self.bars = bars
        self.startBuildTime = bars.min(by: { $0.start < $1.start })?.start ?? 0
        self.finishBuildTime = bars.max(by: { $0.end < $1.end })?.end ?? 0
    }
}
