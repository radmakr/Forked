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
            MainPresenter()
                .environment(state.mainState)
        case .splash:
            SplashPresenter()
                .environment(state.splashState)
        }
    }
}

#if DEBUG
#Preview(traits: .sampleRecipes) {
    @Previewable @State var state = AppState()
    
    AppPresenter()
        .environment(state)
        .setupServices()
        .task {
            try? await Task.sleep(for: .seconds(2))
            state.goToMain()
        }
}
#endif
