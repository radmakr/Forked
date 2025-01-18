//
//  AppPresenter.swift
//  Forked
//
//  Created by Thomas Rademaker on 1/18/25.
//

import SwiftUI

struct AppPresenter: View {
    @Environment(AppState.self) private var state
    
    var body: some View {
        @Bindable var state = state
        switch state.route {
        case .main:
            Text("MAIN")
                .environment(state.mainState)
        case .splash:
            Text("SPLASH")
                .environment(state.splashState)
        }
    }
}

#Preview {
    AppPresenter()
        .environment(AppState())
}
