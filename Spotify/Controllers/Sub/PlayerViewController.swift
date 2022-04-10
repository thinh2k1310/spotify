//
//  PlayerViewController.swift
//  Spotify
//
//  Created by Truong Thinh on 17/03/2022.
//

import UIKit
import SDWebImage

protocol PlayerViewControllerDelegate : AnyObject{
    func didTapPlayPause()
    func didTapBackward()
    func didTapForward()
    func didSlideSlider(_ value : Float)
}

class PlayerViewController: UIViewController {
    
    weak var dataSource : PlayerDatasource?
    weak var delegate : PlayerViewControllerDelegate?

    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let playerControlView : PlayerControlView = {
       let view = PlayerControlView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(playerControlView)
        playerControlView.delegate = self
        configureBarButton()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.width)
        playerControlView.frame = CGRect(
            x: 10,
            y: imageView.bottom + 10,
            width: view.width - 20,
            height: view.height - imageView.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 15)
        
    }
    
    private func configureBarButton(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapAction))
        
    }
    
    private func configure(){
        imageView.sd_setImage(with: dataSource?.imageURL, completed: nil)
        playerControlView.configure(with: PlayerControlViewModel(
            songName: dataSource?.songName ?? "",
            artistName: dataSource?.artistName ?? ""))
    }

    @objc func didTapClose(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapAction(){
        //
    }
    func refreshUI(){
        configure()
    }

}

extension PlayerViewController : PlayerControlViewDelegate{
    func didTapPlayPause(_ playerControlView: PlayerControlView) {
        delegate?.didTapPlayPause()
    }
    
    func didTapForward(_ playerControlView: PlayerControlView) {
        delegate?.didTapForward()
    }
    
    func didTapBackward(_ playerControlView: PlayerControlView) {
        delegate?.didTapBackward()
    }
    func playerControlView(_ playerControlView: PlayerControlView, didSlideSlider value: Float) {
        delegate?.didSlideSlider(value)
    }
}
