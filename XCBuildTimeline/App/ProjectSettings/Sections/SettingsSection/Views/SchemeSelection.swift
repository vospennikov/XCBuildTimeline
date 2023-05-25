//
//  SchemeSelection.swift
//  XCBuildTimeline
//
//  Created by Mikhail Vospennikov on 02.05.2023.
//

import SwiftUI

struct SchemeSelection: View {
    var workspaces: [URL]
    var schemes: [String] = []
    
    @Binding
    var selectedWorkspace: URL
    @Binding
    var selectedScheme: String
        
    var body: some View {
        VStack {
            Picker("Workspace", selection: $selectedWorkspace) {
                ForEach(workspaces, id: \.self) { workspace in
                    Text(workspace.lastPathComponent)
                }
            }
            textPicker(prompt: "Scheme", values: schemes, binding: $selectedScheme)
        }
        .labelsHidden()
    }
    
    @ViewBuilder
    private func textPicker(prompt: String, values: [String], binding: Binding<String>) -> some View {
        if values.isEmpty || binding.wrappedValue.isEmpty {
            TextField(text: binding, prompt: Text(prompt), label: { Text(prompt) })
                .lineLimit(1)
                .autocorrectionDisabled()
        } else {
            Picker(prompt, selection: binding) {
                ForEach(values, id: \.self) { value in
                    Text(value)
                }
            }
        }
    }
}

struct SchemeSelection_Previews: PreviewProvider {
    static var previews: some View {
        SchemeSelection(
            workspaces: [URL(filePath: "Workspace A"), URL(filePath: "Workspace B")],
            selectedWorkspace: .constant(URL(filePath: "Workspace A")),
            selectedScheme: .constant("Scheme 1")
        )
    }
}
