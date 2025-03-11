//
//  VideoPlayerView.swift
//  VerbaChall
//
//  Created by Yaro4ka on 11.03.2025.
//

import SwiftUI
import AVKit
import ComposableArchitecture

struct VideoPlayerView: View {
    let store: Store<AppFeature.State, AppFeature.Action>
    @ObservedObject private var viewStore: ViewStore<AppFeature.State, AppFeature.Action>
    private let player = AVPlayer(url: URL(string: "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4")!)
    
    @State private var timeObserver: Any?  // Store observer in @State

    
    init(store: Store<AppFeature.State, AppFeature.Action>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
        ZStack {
            AVPlayerControllerRepresented(player: player)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    Task {
                        let  duration = try await player.currentItem?.asset.load(.duration).seconds ?? 0.0
                        viewStore.send(.setDuration(duration))
                    }
                    addTimeObserver()
                }
                .overlay(
                    VerbaOverlay(player: player, viewStore: viewStore) // Pass ViewStore for real-time updates
                )
                .onTapGesture {
                    viewStore.send(.toggleControls)
                }
            
            if viewStore.showControls {
                VStack {
                    Spacer()
                    Button(action: {
                        viewStore.send(.playPauseTapped)
                        if viewStore.isPlaying {
                            player.play()
                        } else {
                            player.pause()
                        }
                    }) {
                        Image(systemName: viewStore.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .foregroundColor(.white).opacity(0.5)
                            .shadow(radius: 5)
                    }
                    Spacer()
                    Slider(value: Binding(
                        get: { viewStore.progress },
                        set: { newValue in
                            viewStore.send(.updateProgress(newValue))
                            let newTime = CMTime(seconds: newValue * viewStore.duration, preferredTimescale: 600)
                            player.seek(to: newTime)
                        }
                    ), in: 0...1)
                    .padding()
                }
                .background(Color.black.opacity(0.5))
                .animation(.easeInOut, value: viewStore.showControls)
            }
        }
        .onDisappear {
            if let observer = timeObserver {
                player.removeTimeObserver(observer)
            }
        }
    }
    
    private func addTimeObserver() {
        let interval = CMTime(seconds: 1, preferredTimescale: 600)
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { time in
            let progress = time.seconds / viewStore.duration
            viewStore.send(.updateProgress(progress))
        }
    }
}

#Preview {
    VideoPlayerView(store: Store(initialState: AppFeature.State()) {
        AppFeature()
    })
}
