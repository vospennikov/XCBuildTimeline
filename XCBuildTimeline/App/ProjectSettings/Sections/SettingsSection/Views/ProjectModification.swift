//
//  XcodeprojModifyView.swift
//  XCBuildTimeline
//
//  Created by Mikhail Vospennikov on 05.05.2023.
//

import SwiftUI

struct ProjectModification: View {
    var root: URL?
    var projects: [URL]
    
    @Injected(\.timlineScriptInstaller)
    private var scriptInstaller: TimlineScriptInstaller
    
    var body: some View {
        HStack {
            Button("Install scripts", action: {
                guard let root else { return }
                projects.forEach {
                    try? scriptInstaller.install(root, $0)
                }
            })
            Button("Uninstall scripts", action: {
                projects.forEach {
                    try? scriptInstaller.uninstall($0)
                }
            })
        }
    }
}

struct ProjectModification_Previews: PreviewProvider {
    static var previews: some View {
        ProjectModification(root: URL(filePath: "/tmp"),projects: [])
    }
}
