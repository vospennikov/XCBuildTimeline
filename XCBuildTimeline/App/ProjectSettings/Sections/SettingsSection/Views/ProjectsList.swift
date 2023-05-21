//
//  ProjectsList.swift
//  XCBuildTimeline
//
//  Created by Mikhail Vospennikov on 20.05.2023.
//

import SwiftUI

struct ProjectsList: View {
    let projects: [String]
    
    var body: some View {
        DisclosureGroup("Projects") {
            LazyVStack(alignment: .leading) {
                ForEach(projects, id: \.self) { project in
                    Text(project)
                }
            }
        }
    }
}

struct ProjectsList_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsList(
            projects: ["FeatureA", "FeatureB", "FeatureC"]
        )
    }
}
