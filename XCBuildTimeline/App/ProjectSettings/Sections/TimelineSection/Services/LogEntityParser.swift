//
//  LogEntityParser.swift
//  XCBuildTimeline
//
//  Created by Mikhail Vospennikov on 13.05.2023.
//

import Foundation

struct LogEntityParser {
    var read: (_ logPath: URL) throws -> [LogEntityParserKey.Entity]
    var canReadFile: (_ filePath: URL) -> Bool
}

struct LogEntityParserKey: InjectionKey {
    struct Entity: Codable, Hashable {
        let timestamp: Int
        let target: String
        let event: String
    }
    
    static var currentValue = LogEntityParser(
        read: { logPath -> [Entity] in
            let fileContents = try String(contentsOfFile: logPath.path(), encoding: .utf8)
            let lines = fileContents.components(separatedBy: .newlines)
            
            var entities = [Entity]()
            
            for line in lines where line.notEmpty {
                guard let data = line.data(using: .utf8) else {
                    continue
                }
                
                let decoder = JSONDecoder()
                let entity = try decoder.decode(Entity.self, from: data)
                
                entities.append(entity)
            }

            return entities
        },
        canReadFile: { filePath -> Bool in
            filePath.pathExtension == "json"
        }
    )
}
