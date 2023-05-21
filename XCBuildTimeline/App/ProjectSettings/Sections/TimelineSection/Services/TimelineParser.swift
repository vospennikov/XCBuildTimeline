//
//  TimelineParser.swift
//  XCBuildTimeline
//
//  Created by Mikhail Vospennikov on 13.05.2023.
//

import Foundation

struct TimelineParser {
    var read: (_ logPath: URL) throws -> Timeline
    var canReadFile: (_ filePath: URL) -> Bool
}

struct TimelineParserKey: InjectionKey {
    private struct LogEntity: Codable, Hashable {
        let timestamp: Int
        let target: String
        let event: String
    }
    
    static var currentValue = TimelineParser(
        read: { logPath -> Timeline in
            let fileContents = try String(contentsOfFile: logPath.path(), encoding: .utf8)
            
            let lines = fileContents.components(separatedBy: .newlines)
            
            var logEntries = Set<LogEntity>()
            var startBuiltTime = 0
            
            for line in lines where line.notEmpty {
                guard let data = line.data(using: .utf8) else {
                    continue
                }
                
                let decoder = JSONDecoder()
                let logEntry = try decoder.decode(LogEntity.self, from: data)
                
                startBuiltTime = startBuiltTime == 0 ? logEntry.timestamp : min(startBuiltTime, logEntry.timestamp)
                
                logEntries.insert(logEntry)
            }
            
            let bars = logEntries
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
                .map { (target: String, timestamps: (Int?, Int?)) -> Timeline.Bar? in
                    guard let startTime = timestamps.0, let finishTime = timestamps.1 else {
                        return nil
                    }
                    return Timeline.Bar(name: target, start: startTime - startBuiltTime, end: finishTime - startBuiltTime)
                }
                .compactMap { $0 }
                .sorted { lhs, rhs in
                    lhs.start < rhs.start
                }
            
            return Timeline(bars: bars)
        },
        canReadFile: { filePath -> Bool in
            filePath.pathExtension == "json"
        }
    )
}
