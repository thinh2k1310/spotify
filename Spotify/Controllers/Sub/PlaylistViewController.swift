//
//  PlaylistViewController.swift
//  Spotify
//
//  Created by Truong Thinh on 17/03/2022.
//

import UIKit

class PlaylistViewController: UIViewController {

    private let playlist : Playlist
    
    init(playlist : Playlist) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = playlist.name
        view.backgroundColor = .systemBackground

        APICaller.shared.getPlaylistDetail(playlist: playlist) { result in
            DispatchQueue.main.async {
                switch result{
                case  .success(let model):
                    break
                case  .failure(let error):
                    break
                }
            }
        }
    }
}
