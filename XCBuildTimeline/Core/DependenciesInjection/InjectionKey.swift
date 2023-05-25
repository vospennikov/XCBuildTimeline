//
//  InjectionKey.swift
//  XCBuildTimeline
//
//  Created by Mikhail Vospennikov on 05.05.2023.
//

import Foundation

protocol InjectionKey {
    associatedtype Value
    static var currentValue: Self.Value { get set }
}
