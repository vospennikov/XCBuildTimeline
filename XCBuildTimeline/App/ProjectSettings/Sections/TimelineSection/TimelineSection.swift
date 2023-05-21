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
    
    @Injected(\.timelineParser)
    private var timelineParser: TimelineParser
    
    var body: some View {
        Section("Timeline") {
            TimelineFileSelection(timelineFile: $timelineFile)
            
            if let timelineFile, let timeline = try? timelineParser.read(timelineFile) {
                NavigationLink("Show charts", value: timeline)
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
