//
//  ProjectBuild.swift
//  XCBuildTimeline
//
//  Created by Mikhail Vospennikov on 11.05.2023.
//

import SwiftUI
import Shell

struct ProjectBuild: View {
    let workspace: URL
    let scheme: String
    
    @State
    private var viewState = ViewState.ready
    private enum ViewState {
        case ready
        case building
    }
    
    @State
    private var viewError: ViewError?
    @State
    private var isPresentedError = false
    
    @Injected(\.shellExecutor)
    private var shell: Shell
    
    var body: some View {
        actionButtons
        .alert(isPresented: $isPresentedError, error: viewError)
        .onChange(of: viewError) { newValue in
            isPresentedError = true
        }
    }
    
    @ViewBuilder
    private var actionButtons: some View {
        switch viewState {
            case .ready:
                HStack {
                    Button("Build", action: buildAction)
                    Button("Open in Xcode", action: openXcodeAction)
                    Button("Remove DerivedData", action: cleanDeriveData)
                }
            case .building:
                ProgressView()
                    .controlSize(.small)
        }
    }
    
    private func buildAction() {
        DispatchQueue.global(qos: .default).async {
            viewState = .building
            defer { viewState = .ready }
            do {
                try shell(.xcodebuild(workspace: workspace, scheme: scheme, options: .clean, .build))
            } catch {
                viewError = ViewError(failureReason: error.localizedDescription)
            }
        }
    }
    
    private func openXcodeAction() {
        do {
            try shell(.xed("\(workspace.path())"))
        } catch {
            viewError = ViewError(failureReason: error.localizedDescription)
        }
    }
    
    private func cleanDeriveData() {
        do {
            try shell(.plain("rm -rf ~/Library/Developer/Xcode/DerivedData/*"))
        } catch {
            viewError = ViewError(failureReason: error.localizedDescription)
        }
    }
}

struct ProjectBuild_Previews: PreviewProvider {
    static var previews: some View {
        ProjectBuild(
            workspace: URL(filePath: "/tmp"),
            scheme: "Scheme"
        )
    }
}
