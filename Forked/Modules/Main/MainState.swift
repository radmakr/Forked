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
        case recipe(Recipe)
    }
    
    private unowned let parentState: AppState
    var path: [Path] = []
    var askToDelete = false
    var triggerDelete = false
    
    init(parentState: AppState) {
        self.parentState = parentState
    }
}
