//
//  AppFeature.swift
//  VerbaChall
//
//  Created by Yaro4ka on 11.03.2025.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct AppFeature {
    struct State: Equatable {
        var isPlaying: Bool = false
        var showControls: Bool = true
        var progress: Double = 0.0
        var duration: Double = 1.0
    }
    
    enum Action {
        case playPauseTapped
        case toggleControls
        case updateProgress(Double)
        case setDuration(Double)
        case hideControls
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .playPauseTapped:
            state.isPlaying.toggle()
            return .run { send in
                try await Task.sleep(nanoseconds: 3_000_000_000) // 3-second delay
                await send(.hideControls)
            }
            
        case .toggleControls:
            state.showControls.toggle()
            return .run { send in
                try await Task.sleep(nanoseconds: 3_000_000_000) // 3-second delay
                await send(.hideControls)
            }
            
        case .updateProgress(let progress):
            state.progress = progress
            return .none
            
        case .setDuration(let duration):
            state.duration = duration
            return .none
            
        case .hideControls:
            state.showControls = false
            return .none
        }
    }
}
