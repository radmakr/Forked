//
//  AppState.swift
//  Forked
//
//  Created by Thomas Rademaker on 1/18/25.
//

import SwiftUI

@MainActor
@Observable
class AppState {
    enum Route: Int, Identifiable {
        case splash
        case main
        
        var id: Int { rawValue }
    }
    
    var route: Route = .main
    
    @ObservationIgnored
    lazy var mainState = MainState(parentState: self)
    @ObservationIgnored
    lazy var splashState = SplashState(parentState: self)
}
