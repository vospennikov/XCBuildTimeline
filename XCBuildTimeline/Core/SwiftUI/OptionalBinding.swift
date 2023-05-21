//
//  OptionalBinding.swift
//  XCBuildTimeline
//
//  Created by Mikhail Vospennikov on 11.05.2023.
//

import SwiftUI

extension Binding {
    static func ??(lhs: Binding<Optional<Value>>, rhs: Value) -> Self {
        Binding(
            get: { lhs.wrappedValue ?? rhs },
            set: { lhs.wrappedValue = $0 }
        )
    }
}
