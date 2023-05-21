//
//  EnvironmentValues.swift
//  XCBuildTimeline
//
//  Created by Mikhail Vospennikov on 21.10.2022.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
    var isPreview: Bool { ProcessInfo.processInfo.isPreview }
}

extension ProcessInfo {
    var isPreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
