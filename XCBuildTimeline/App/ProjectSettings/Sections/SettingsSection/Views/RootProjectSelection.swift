//
//  RootProjectSelection.swift
//  XCBuildTimeline
//
//  Created by Mikhail Vospennikov on 28.04.2023.
//

import SwiftUI
import AppKit

struct RootProjectSelection: View {
    @Binding
    var root: URL?
    
    @State
    private var viewError: ViewError?
    @State
    private var isPresentedError = false
    
    var body: some View {
        HStack {
            Button("Select", action: { presentOpenPanel() })
            Text(placeholder)
                .onDrop(of: [.fileURL], isTargeted: nil) { (providers: [NSItemProvider]) in
                    handleDropURLs(providers)
                }
        }
        .alert(isPresented: $isPresentedError, error: viewError)
        .onChange(of: viewError) { newValue in
            isPresentedError = true
        }
    }
    
    private var placeholder: String {
        if let root {
            return root.path()
        } else {
            return "Select or drop a project directory here for modifying and build."
        }
    }
    
    @MainActor
    private func presentOpenPanel() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        switch panel.runModal() {
            case .OK:
                guard let url = panel.url else { return }
                root = url
            default:
                break
        }
    }
    
    private func handleDropURLs(_ providers: [NSItemProvider]) -> Bool {
        guard let provider = providers.first(where: { $0.canLoadObject(ofClass: URL.self) }) else {
            return false
        }

        let _ = provider.loadObject(ofClass: URL.self) { itemProviderReading, providerError in
            if let providerError {
                viewError = ViewError(failureReason: providerError.localizedDescription)
                return
            }
            guard let itemProviderReading else {
                return
            }
            root = itemProviderReading
        }
        
        return true
    }
}

struct RootProjectSelection_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading) {
            RootProjectSelection(root: .constant(nil))
            RootProjectSelection(root: .constant(URL(string: "/project/Test/")!))
        }
    }
}
