//
//  SplashState.swift
//  Forked
//
//  Created by Thomas Rademaker on 1/18/25.
//

import SwiftUI

@MainActor
@Observable
class SplashState {
    private unowned let parentState: AppState
    
    init(parentState: AppState) {
        self.parentState = parentState
    }
}
