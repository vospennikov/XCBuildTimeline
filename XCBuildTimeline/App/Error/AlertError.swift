//
//  AlertError.swift
//  XCBuildTimeline
//
//  Created by Mikhail Vospennikov on 05.05.2023.
//

import SwiftUI

struct AlertError: ViewModifier {
    @Binding var isPresented: Bool
    var error: ViewError?
    
    func body(content: Content) -> some View {
        content
            .alert(
                isPresented: $isPresented,
                error: error,
                actions: { error in
                    if let suggestion = error.recoverySuggestion {
                        Text(suggestion)
                    }
                },
                message: { error in
                    if let failureReason = error.failureReason {
                        Text(failureReason)
                    } else {
                        Text("Something went wrong")
                    }
                }
            )
    }
}

extension View {
    func alert(isPresented: Binding<Bool>, error: ViewError?) -> some View {
        modifier(AlertError(isPresented: isPresented, error: error))
    }
}
