//
//  LibraryToggleView.swift
//  Spotify
//
//  Created by Truong Thinh on 11/04/2022.
//

import UIKit

protocol LibraryToggleViewDelegate : AnyObject{
    func didTapPlaylists(_ toggleView: LibraryToggleView)
    func didTapAlbums(_ toggleView: LibraryToggleView)
}

class LibraryToggleView: UIView {
    
    enum State {
        case playlists
        case albums
    }
    
    var state : State = .playlists
    
    weak var delegate : LibraryToggleViewDelegate?

    private let playlistsButton : UIButton = {
       let button = UIButton()
        button.setTitle("Playlists", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    private let albumsButton : UIButton = {
       let button = UIButton()
        button.setTitle("Albums", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    private let indicatorView : UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        return view
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(playlistsButton)
        addSubview(albumsButton)
        addSubview(indicatorView)
        
        playlistsButton.addTarget(self, action: #selector(didTapPlaylists), for: .touchUpInside)
        albumsButton.addTarget(self, action: #selector(didTapAlbums), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc func didTapPlaylists(){
        state = .playlists
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
        delegate?.didTapPlaylists(self)
    }
    
    @objc func didTapAlbums(){
        state = .albums
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
        delegate?.didTapAlbums(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playlistsButton.frame = CGRect(x: 0, y: 0, width: width/2, height: 30)
        albumsButton.frame = CGRect(x: playlistsButton.right, y: 0, width: width/2,height: 30)
        layoutIndicator()
    }
    
    private func layoutIndicator(){
        switch state {
        case .playlists:
            indicatorView.frame = CGRect(x: 0, y: playlistsButton.bottom, width: width/2, height: 1)
        case .albums:
            indicatorView.frame = CGRect(x: playlistsButton.right, y: playlistsButton.bottom, width: width/2, height: 1)
        }
    }
    
    func updateForState(_ state : State){
        self.state = state
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
    }
}
