//
//  VerbaOverlay.swift
//  VerbaChall
//
//  Created by Yaro4ka on 11.03.2025.
//

import SwiftUI
import AVKit
import ComposableArchitecture

// MARK: - Synced Overlay
struct VerbaOverlay: UIViewRepresentable {
    var player: AVPlayer
    var viewStore: ViewStore<AppFeature.State, AppFeature.Action> // Use state updates
    
    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()
        
        let syncLayer = AVSynchronizedLayer()
        syncLayer.playerItem = player.currentItem
        syncLayer.frame = containerView.bounds
        containerView.layer.addSublayer(syncLayer)
        
        let textLayer = CATextLayer()
        textLayer.string = "Verba✨"
        textLayer.font = UIFont.boldSystemFont(ofSize: 40)
        textLayer.foregroundColor = UIColor.white.cgColor
        textLayer.alignmentMode = .center
        textLayer.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        textLayer.opacity = 0 // Initially hidden
        syncLayer.addSublayer(textLayer)
        
        context.coordinator.textLayer = textLayer
        context.coordinator.syncWithPlayer()
        
        return containerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(player: player, viewStore: viewStore)
    }
    
    class Coordinator {
        var player: AVPlayer
        var viewStore: ViewStore<AppFeature.State, AppFeature.Action>
        var textLayer: CATextLayer?
        
        init(player: AVPlayer, viewStore: ViewStore<AppFeature.State, AppFeature.Action>) {
            self.player = player
            self.viewStore = viewStore
        }
        
        func syncWithPlayer() {
            let interval = CMTime(seconds: 0.1, preferredTimescale: 600)
            player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
                guard let self = self, let textLayer = self.textLayer else { return }
                let currentTime = time.seconds
                
                // Text appears from 3s to 8s
                if currentTime >= 3 && currentTime <= 8 {
                    textLayer.opacity = 1
                } else {
                    textLayer.opacity = 0
                }
            }
        }
    }
}
