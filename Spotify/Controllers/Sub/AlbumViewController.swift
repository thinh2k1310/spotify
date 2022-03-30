//
//  AlbumViewController.swift
//  Spotify
//
//  Created by Truong Thinh on 30/03/2022.
//

import UIKit

class AlbumViewController: UIViewController {
    
    private let album : Album
    
    init(album : Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = album.name
        view.backgroundColor = .systemBackground
        APICaller.shared.getAlbumDetail(album: album) { result in
            DispatchQueue.main.async {
                switch result{
                case .success(let model):
                    print(model)
                    break
                case .failure(let error):
                    print(error)
                    break
                }
            }
        }
    }
    
    
}
