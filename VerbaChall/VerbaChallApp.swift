//
//  VerbaChallApp.swift
//  VerbaChall
//
//  Created by Yaro4ka on 11.03.2025.
//

import SwiftUI
import ComposableArchitecture

@main
struct VerbaChallApp: App {
    var body: some Scene {
        WindowGroup {
            VideoPlayerView(store: Store(initialState: AppFeature.State()) {
                AppFeature()
            })
        }
    }
}
