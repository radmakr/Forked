//
//  MainState.swift
//  Forked
//
//  Created by Thomas Rademaker on 1/18/25.
//

import SwiftUI

@MainActor
@Observable
class MainState {
    enum Path: Hashable {
        case recipe
    }
    
    private unowned let parentState: AppState
    var path: [Path] = []
    
    init(parentState: AppState) {
        self.parentState = parentState
    }
}
