//
//  InjectionKey.swift
//  XCBuildTimeline
//
//  Created by Mikhail Vospennikov on05.05.2023.
//

import Foundation

protocol InjectionKey {
    associatedtype Value
    static var currentValue: Self.Value { get set }
}
