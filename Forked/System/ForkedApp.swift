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
    
    var body: some Scene {
        WindowGroup {
            AppPresenter()
                .environment(state)
                .setupServices()
                .setupModel()
        }
    }
}
