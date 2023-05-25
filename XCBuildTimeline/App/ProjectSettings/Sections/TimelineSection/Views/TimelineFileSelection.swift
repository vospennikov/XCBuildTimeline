//
//  TimelineFileSelection.swift
//  XCBuildTimeline
//
//  Created by Mikhail Vospennikov on 11.05.2023.
//

import SwiftUI

struct TimelineFileSelection: View {
    @Binding
    var timelineFile: URL?
    
    @State
    private var viewError: ViewError?
    @State
    private var isPresentedError = false
    
    @Injected(\.logEntityParser)
    private var logEntityParser: LogEntityParser
    
    var body: some View {
        HStack {
            Button("Select", action: presentOpenPanel)
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
        if let timelineFile {
            return timelineFile.path()
        } else {
            return "Select or drop a timing file (.json) here to show the build timeline."
        }
    }
    
    private func presentOpenPanel() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowedContentTypes = [.fileURL]
        panel.allowsMultipleSelection = false
        panel.allowsOtherFileTypes = false
        
        switch panel.runModal() {
            case .OK:
                guard let url = panel.url, logEntityParser.canReadFile(url) else {
                    return
                }
                timelineFile = url
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
            guard let itemProviderReading, logEntityParser.canReadFile(itemProviderReading) else {
                return
            }
            timelineFile = itemProviderReading
        }
        
        return true
    }
}

struct TimelineFileSelection_Previews: PreviewProvider {
    static var previews: some View {
        TimelineFileSelection(
            timelineFile: .constant(nil)
        )
        .padding()
    }
}
