//
//  SplashPresenter.swift
//  Forked
//
//  Created by Thomas Rademaker on 1/18/25.
//

import SwiftUI

struct SplashPresenter: View {
    @Environment(SplashState.self) private var state
    
    var body: some View {
        SplashView()
            .task { await goToMain() }
    }
    
    private func goToMain() async {
        guard !isCanvas else { return }
        try? await Task.sleep(for: .seconds(2))
        state.goToMain()
    }
}

fileprivate struct SplashView: View {
    var body: some View {
        HStack {
            Text("Forked")
            Image(systemName: "fork.knife")
        }
        .font(.title)
        .foregroundStyle(Color.accentColor)
    }
}

#Preview {
    SplashPresenter()
        .environment(SplashState(parentState: AppState()))
}
