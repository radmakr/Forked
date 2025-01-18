//
//  SplashPresenter.swift
//  Forked
//
//  Created by Thomas Rademaker on 1/18/25.
//

import SwiftUI

struct SplashPresenter: View {
    var body: some View {
        SplashView()
    }
}

fileprivate struct SplashView: View {
    var body: some View {
        Text("SPLASH")
    }
}

#Preview {
    SplashPresenter()
        .environment(SplashState(parentState: AppState()))
}
