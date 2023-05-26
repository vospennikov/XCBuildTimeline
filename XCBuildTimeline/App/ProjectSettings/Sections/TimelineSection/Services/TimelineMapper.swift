//
//  TimelineMapper.swift
//  XCBuildTimeline
//
//  Created by Mikhail Vospennikov on 25.05.2023.
//

import Foundation

struct TimelineMapper {
    var map: (_ entities: [LogEntityParserKey.Entity]) -> BuildTimeline.ChartData
}

struct TimelineMapperKey: InjectionKey {
    static var currentValue = TimelineMapper(
        map: { (entities: [LogEntityParserKey.Entity]) -> BuildTimeline.ChartData in
            var startBuildTime = entities
                .min { lhs, rhs in
                    lhs.timestamp < rhs.timestamp
                }?
                .timestamp ?? 0
            
            let bars = entities
                .reduce(into: [String: (Int?, Int?)]()) { partialResult, newValue in
                    switch newValue.event {
                        case "start":
                            partialResult[newValue.target] = (newValue.timestamp, partialResult[newValue.target]?.1)
                        case "end":
                            partialResult[newValue.target] = (partialResult[newValue.target]?.0, newValue.timestamp)
                        default:
                            break
                    }
                }
                .map { (target: String, timestamps: (Int?, Int?)) -> BuildTimeline.ChartData.Bar? in
                    guard let startTime = timestamps.0, let finishTime = timestamps.1 else {
                        return nil
                    }
                    return BuildTimeline.ChartData.Bar(
                        name: target,
                        start: startTime - startBuildTime,
                        end: finishTime - startBuildTime
                    )
                }
                .compactMap { $0 }
                .sorted { lhs, rhs in
                    lhs.start < rhs.start
                }
            
            return BuildTimeline.ChartData(bars: bars)
        }
    )
}
