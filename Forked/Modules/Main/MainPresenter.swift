//
//  MainPresenter.swift
//  Forked
//
//  Created by Thomas Rademaker on 1/18/25.
//

import SwiftUI
import SwiftData

struct MainPresenter: View {
    @Environment(MainState.self) private var state
    
    var body: some View {
        @Bindable var state = state
        
        NavigationStack(path: $state.path) {
            MainView()
        }
    }
}

fileprivate struct MainView: View {
    var body: some View {
        Text("MAIN")
    }
}

#if DEBUG
#Preview(traits: .sampleRecipes) {
    MainPresenter()
        .environment(MainState(parentState: AppState()))
}
#endif
