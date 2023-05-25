//
//  TimelineScriptInstaller.swift
//  XCBuildTimeline
//
//  Created by Mikhail Vospennikov on 26.04.2023.
//

import Foundation
import XcodeProj
import PathKit

struct TimelineScriptInstaller {
    var install: (_ root: URL, _ project: URL) throws -> Void
    var uninstall: (_ project: URL) throws -> Void
}

struct TimelineScriptInstallerKey: InjectionKey {
    static var currentValue = TimelineScriptInstaller(
        install: { root, project in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM_HH:mm"
            let currentDate = Date()
            let formattedDate = dateFormatter.string(from: currentDate)
            
            let buildScript: (String) -> String = { event -> String in
                """
                TIMESTAMP=`date +%s`
                echo '{"timestamp": '$TIMESTAMP', "target": "'$TARGET_NAME'", "event": "\(event)"}' >> '\(root.path())timeline_\(formattedDate).json'
                """
            }
            let path = Path(project.path())
            let xcodeproj = try XcodeProj(path: path)
            let pbxproj = xcodeproj.pbxproj
            
            if pbxproj.buildPhases.lazy.first(where: { phase in phase.name() == "Start" }) == nil {
                let startScript = PBXShellScriptBuildPhase(
                    name: "Start",
                    shellScript: buildScript("start")
                )
                pbxproj.add(object: startScript)
                
                for target in pbxproj.nativeTargets {
                    target.buildPhases.insert(startScript, at: 0)
                }
            }
            
            if pbxproj.buildPhases.lazy.first(where: { phase in phase.name() == "End" }) == nil {
                let endScript = PBXShellScriptBuildPhase(
                    name: "End",
                    shellScript: buildScript("end")
                )
                pbxproj.add(object: endScript)
                
                for target in pbxproj.nativeTargets {
                    target.buildPhases.append(endScript)
                }
            }
            
            try xcodeproj.write(path: path, override: true)
        },
        uninstall: { project in
            let path = Path(project.path())
            let xcodeproj = try XcodeProj(path: path)
            let pbxproj = xcodeproj.pbxproj
            
            pbxproj.buildPhases
                .lazy
                .filter { phase -> Bool in
                    phase.name() == "Start" || phase.name() == "End"
                }
                .forEach { phase in
                    pbxproj.delete(object: phase)
                }
            
            pbxproj.nativeTargets.forEach { target in
                target.buildPhases.removeAll { phase in
                    phase.name() == "Start" || phase.name() == "End"
                }
            }
            
            try xcodeproj.write(path: path, override: true)
        }
    )
}
