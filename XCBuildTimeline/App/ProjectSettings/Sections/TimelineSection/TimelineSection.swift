//
//  TimelineSection.swift
//  XCBuildTimeline
//
//  Created by Mikhail Vospennikov on 20.05.2023.
//

import SwiftUI

struct TimelineSection: View {
    @State
    private var timelineFile: URL?
    
    @Injected(\.logEntityParser)
    private var logEntityParser: LogEntityParser
    
    @Injected(\.timelineMapper)
    private var timelineMapper: TimelineMapper
    
    var body: some View {
        Section("Timeline") {
            TimelineFileSelection(timelineFile: $timelineFile)
            
            if let timelineFile,
               let logEntities = try? logEntityParser.read(timelineFile) {
                NavigationLink("Show charts", value: timelineMapper.map(logEntities))
            }
        }
    }
}

struct TimelineSection_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            TimelineSection()
        }
    }
}
