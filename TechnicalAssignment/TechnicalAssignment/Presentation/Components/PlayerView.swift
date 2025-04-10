//
//  PlayerView.swift
//  TechnicalAssignment
//
//  Created by Jamie on 09/04/2025.
//

import SwiftUI
import AVKit

final class PlayerView: UIView {
    
    fileprivate var videoURL: URL?
    fileprivate var queuePlayer: AVQueuePlayer?
    fileprivate var playerLayer: AVPlayerLayer?
    fileprivate var playerLooper: AVPlayerLooper?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        self.playerLayer?.frame = self.bounds
    }
    
    func prepareVideo(_ videoUrl: URL) {
        let playerItem = AVPlayerItem(url: videoUrl)
        queuePlayer = AVQueuePlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: self.queuePlayer)
        
        guard let playerLayer,
              let queuePlayer else { return }
        
        self.playerLooper = AVPlayerLooper(player: queuePlayer,
                                           templateItem: playerItem)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = self.frame
        self.layer.addSublayer(playerLayer)
    }
    
    func play() {
        self.queuePlayer?.play()
    }
    
    func pause() {
        self.queuePlayer?.pause()
    }
    
    func unload() {
        self.playerLayer?.removeFromSuperlayer()
        self.playerLayer = nil
        self.queuePlayer = nil
        self.playerLayer = nil
    }
    
}

struct PlayerContainerView: UIViewRepresentable {
    
    typealias UIViewType = PlayerView
    let playerView: PlayerView
    var url: URL?
    
    init(playerView: PlayerView, url: URL? = nil) {
        self.playerView = playerView
        self.url = url
        
        guard let url else {
            return
        }
        self.prepareVideo(url)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            playerView.play()
        }
    }
    
    func makeUIView(context: Context) -> PlayerView {
        return playerView
    }
    
    func updateUIView(_ uiView: PlayerView, context: Context) {}
    
    func play() {
        playerView.play()
    }
    
    func pause() {
        playerView.pause()
    }
    
    func prepareVideo(_ videoUrl: URL) {
        playerView.prepareVideo(videoUrl)
    }
    
    func unload() {
        playerView.unload()
    }
}
