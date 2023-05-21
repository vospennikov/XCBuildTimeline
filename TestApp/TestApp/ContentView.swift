//
//  ContentView.swift
//  TestApp
//
//  Created by Mikhail Vospennikov on 27.04.2023.
//

import SwiftUI

import Alamofire
import Charts
import Lottie
import RxSwift
import Kingfisher
import SnapKit
import IQKeyboardManager
import PromiseKit

import FeatureA
import FeatureB

struct ContentView: View {
    let a = FeatureA()
    let b = FeatureB()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            Text(a.hello)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
