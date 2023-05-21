//
//  ViewError.swift
//  XCBuildTimeline
//
//  Created by Mikhail Vospennikov on 05.05.2023.
//

import Foundation

struct ViewError: LocalizedError, Equatable {
    var failureReason: String?
    var recoverySuggestion: String?
    var errorDescription: String?
    var helpAnchor: String?
    
    static func ==(lhs: ViewError, rhs: ViewError) -> Bool {
        lhs.failureReason == rhs.failureReason &&
        lhs.recoverySuggestion == rhs.recoverySuggestion &&
        lhs.errorDescription == rhs.errorDescription &&
        lhs.helpAnchor == rhs.helpAnchor
    }
}
