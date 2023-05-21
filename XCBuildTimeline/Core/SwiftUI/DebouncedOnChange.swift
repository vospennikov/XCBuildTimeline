//
//  DebouncedOnChange.swift
//  XCBuildTimeline
//
//  Created by Mikhail Vospennikov on 05.05.2023.
//

import SwiftUI

struct DebouncedOnChange<Value>: ViewModifier where Value: Equatable {
    let trigger: Value
    let debounceTime: TimeInterval
    let action: (Value) -> Void
    
    @State private var debouncedTask: Task<Void, Never>?
    
    func body(content: Content) -> some View {
        content.onChange(of: trigger) { value in
            debouncedTask?.cancel()
            debouncedTask = Task.delayed(seconds: debounceTime) { @MainActor in
                action(value)
            }
        }
    }
}

extension View {
    public func onChange<Value>(
        of value: Value,
        debounceTime: TimeInterval,
        perform action: @escaping (_ newValue: Value) -> Void
    ) -> some View where Value: Equatable {
        modifier(DebouncedOnChange(trigger: value, debounceTime: debounceTime, action: action))
    }
}
