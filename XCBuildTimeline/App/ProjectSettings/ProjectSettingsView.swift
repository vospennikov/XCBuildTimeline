//
//  ProjectSettingsView.swift
//  XCBuildTimeline
//
//  Created by Mikhail Vospennikov on 05.05.2023.
//

import SwiftUI

struct ProjectSettingsView: View {
    var body: some View {
        Form {
            SettingsSection()
            Divider()
            TimelineSection()
        }
    }
}

struct ProjectSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectSettingsView()
    }
}
