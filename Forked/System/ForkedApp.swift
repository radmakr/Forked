//
//  ForkedApp.swift
//  Forked
//
//  Created by Thomas Rademaker on 1/18/25.
//

import SwiftUI

@main
struct ForkedApp: App {
    @State private var state = AppState()
    @State private var imageFetcher = ImageFetcher()
    
    var body: some Scene {
        WindowGroup {
            AppPresenter()
                .environment(state)
                .environment(\.imageFetcher, imageFetcher)
                .setupServices()
                .setupModel()
        }
    }
}
