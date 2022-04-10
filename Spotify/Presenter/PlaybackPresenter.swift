//
//  PlaybackPresenter.swift
//  Spotify
//
//  Created by Truong Thinh on 09/04/2022.
//

import UIKit
import AVFoundation

protocol PlayerDatasource : AnyObject {
    var songName : String? { get }
    var artistName : String? { get }
    var imageURL : URL? { get }
}

final class PlaybackPresenter{
    
    static let shared = PlaybackPresenter()
    
    var player : AVPlayer?
    var playerQueue: AVQueuePlayer?
    var playerVC : PlayerViewController?
    var index = 0
    
    private var track : AudioTrack?
    private var tracks : [AudioTrack] = []
    
    var currentTrack : AudioTrack? {
        if let track = track, tracks.isEmpty{
            return track
        }
        else if !tracks.isEmpty {
            return tracks[index]
        }
        return nil
    }
    
    func startPlayback(
        from viewController : UIViewController,
        track : AudioTrack){
            guard let url = URL(string: track.preview_url ?? "") else {
                return
            }
            player = AVPlayer(url: url)
            player?.volume = 0.5
            self.tracks = []
            self.track = track
            
            
            let vc = PlayerViewController()
            vc.dataSource = self
            vc.delegate = self
            viewController.present(UINavigationController(rootViewController: vc), animated: true) {[weak self]  in
                self?.player?.play()
                
            }
            self.playerVC = vc
        }
    func startPlayback(
        from viewController : UIViewController,
        tracks : [AudioTrack]){
            self.tracks = tracks
            self.track = nil
            index = 0

            self.playerQueue = AVQueuePlayer(items: tracks.compactMap({
                guard let url = URL(string: $0.preview_url ?? "") else {
                    return nil
                }
                return AVPlayerItem(url: url)
            }))
            self.playerQueue?.volume = 0.5
            player?.play()
            
            let vc = PlayerViewController()
            vc.dataSource = self
            vc.delegate = self
            viewController.present(UINavigationController(rootViewController: vc), animated: true, completion: nil )
            self.playerVC = vc
        }
    
}

extension PlaybackPresenter : PlayerDatasource {
    var songName: String? {
        return currentTrack?.name
    }
    
    var artistName: String? {
        return currentTrack?.artists.first?.name
    }
    
    var imageURL: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? "")
    }
    
    
}

extension PlaybackPresenter : PlayerViewControllerDelegate {
    func didTapPlayPause() {
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
            }
            else if player.timeControlStatus == .paused{
                player.play()
            }
        }
        else if let playerQueue = playerQueue {
            if playerQueue.timeControlStatus == .playing {
                playerQueue.pause()
            }
            else if playerQueue.timeControlStatus == .paused{
                playerQueue.play()
            }
        }
    }
    
    func didTapForward() {
        if tracks.isEmpty {
            player?.pause()
            player?.play()
        }
        else if let playerQueue = playerQueue{
            playerQueue.advanceToNextItem()
            index += 1
            playerVC?.refreshUI()
        }
    }
    
    func didTapBackward() {
        if tracks.isEmpty {
            player?.pause()
            player?.play()
        }
        else if let firstItem = playerQueue?.items().first{
            playerQueue?.pause()
            playerQueue?.removeAllItems()
            playerQueue = AVQueuePlayer(items: [firstItem])
            playerQueue?.play()
            playerQueue?.volume = 0.5
        }
    }
    func didSlideSlider(_ value: Float) {
        player?.volume = value
    }
    
    
}
