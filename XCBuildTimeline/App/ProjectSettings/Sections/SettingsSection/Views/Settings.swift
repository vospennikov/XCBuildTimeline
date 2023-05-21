//
//  Settings.swift
//  XCBuildTimeline
//
//  Created by Mikhail Vospennikov on 20.05.2023.
//

import SwiftUI

struct Settings: View {
    var projectRoot: URL
    var projects: [URL]
    var workspaces: [URL]
    var schemes: [String]
    
    @State
    private var selectedWorkspace: URL
    @State
    private var selectedScheme: String
    
    init(
        projectRoot: URL,
        projects: [URL],
        workspaces: [URL],
        schemes: [String],
        selectedWorkspace: URL,
        selectedScheme: String
    ) {
        self.projectRoot = projectRoot
        self.projects = projects
        self.workspaces = workspaces
        self.schemes = schemes
        self._selectedWorkspace = State(initialValue: selectedWorkspace)
        self._selectedScheme = State(initialValue: selectedScheme)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ProjectsList(projects: projectsPath)
            ProjectModification(root: projectRoot, projects: projects)
            
            SchemeSelection(
                workspaces: workspaces,
                schemes: schemes,
                selectedWorkspace: $selectedWorkspace,
                selectedScheme: $selectedScheme
            )
            
            ProjectBuild(
                workspace: selectedWorkspace,
                scheme: selectedScheme
            )
            .disabled(disabledBuild)
        }
    }
    
    private var projectsPath: [String] {
        projects.map { $0.path() }
    }
    
    private var disabledBuild: Bool {
        selectedScheme.isEmpty
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings(
            projectRoot: URL(filePath: "/tmp/tmp"),
            projects: [],
            workspaces: [],
            schemes: ["Scheme A", "Scheme B"],
            selectedWorkspace: URL(filePath: "/tmp/tmp"),
            selectedScheme: "Scheme A"
        )
    }
}
