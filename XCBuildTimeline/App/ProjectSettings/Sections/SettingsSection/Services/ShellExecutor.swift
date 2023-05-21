//
//  ShellExecutor.swift
//  XCBuildTimeline
//
//  Created by Mikhail Vospennikov on 20.05.2023.
//

import Foundation
import Shell

struct ShellExecutorKey: InjectionKey {
    static var currentValue: Shell = .init()
}
