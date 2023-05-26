//
//  TargetAnnotation.swift
//  XCBuildTimeline
//
//  Created by Mikhail Vospennikov on 25.05.2023.
//

import SwiftUI

struct TargetAnnotation: View {
    var name: String
    var startTime: Int
    var finishTime: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(name)
                .font(.headline)
            Text("start: \(startTime) – finish: \(finishTime)")
                .font(.body)
        }
        .padding()
        .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

struct TargetAnnotation_Previews: PreviewProvider {
    static var previews: some View {
        TargetAnnotation(
            name: "Target",
            startTime: 0,
            finishTime: 15
        )
        .padding()
    }
}
