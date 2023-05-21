//
//  SettingsSection.swift
//  XCBuildTimeline
//
//  Created by Mikhail Vospennikov on 20.05.2023.
//

import SwiftUI

struct SettingsSection: View {
    @State
    private var projectRoot: URL?
    
    @State
    private var viewState = ViewState.noProjectRoot
    private enum ViewState {
        case noProjectRoot
        case projectSettings(selectedRoot: URL, projects: [URL], workspaces: [URL], schemes: [String])
    }
    
    @State
    private var viewError: ViewError?
    @State
    private var isPresentedError = false
    
    @Injected(\.fileFinder)
    private var fileFinder: FileFinder
    @Injected(\.xcodeprojParser)
    private var xcodeprojParser: XcodeprojParser
    
    var body: some View {
        Section("Settings") {
            switch viewState {
                case .noProjectRoot:
                    RootProjectSelection(root: $projectRoot)
                case let .projectSettings(root, projects, workspaces, schemes):
                    RootProjectSelection(root: $projectRoot)
                    let reversedWorkspaces = workspaces.reversed()
                    let reversedSchemes = schemes.reversed()
                    let selectedScheme = reversedSchemes.first ?? ""
                    
                    if let selectedWorkspace = reversedWorkspaces.first {
                        Settings(
                            projectRoot: root,
                            projects: projects,
                            workspaces: Array(reversedWorkspaces),
                            schemes: Array(reversedSchemes),
                            selectedWorkspace: selectedWorkspace,
                            selectedScheme: selectedScheme
                        )
                    }
            }
        }
        .alert(isPresented: $isPresentedError, error: viewError)
        .onChange(of: projectRoot, perform: findProjects)
        .onChange(of: viewError) { newValue in
            isPresentedError = true
        }
    }
    
    private func findProjects(_ newProjectRoot: URL?) {
        guard let newProjectRoot else { return }
        Task {
            do {
                let projects = try await fileFinder.findFilesOfType(newProjectRoot, "xcodeproj")
                let workspaces = try await fileFinder.findFilesOfType(newProjectRoot, "xcworkspace")
                let schemes = try projects.flatMap { project in
                    try xcodeprojParser.findSchemes(project)
                }
                
                viewState = .projectSettings(
                    selectedRoot: newProjectRoot,
                    projects: projects,
                    workspaces: workspaces,
                    schemes: schemes
                )
            } catch {
                viewError = ViewError(errorDescription: error.localizedDescription)
            }
        }
    }
}

struct SettingsSection_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            SettingsSection()
        }
    }
}
