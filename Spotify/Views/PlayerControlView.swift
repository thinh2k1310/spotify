//
//  PlayerControlView.swift
//  Spotify
//
//  Created by Truong Thinh on 09/04/2022.
//

import UIKit

protocol PlayerControlViewDelegate : AnyObject {
    func didTapPlayPause(_ playerControlView : PlayerControlView)
    func didTapBackward(_ playerControlView : PlayerControlView)
    func didTapForward(_ playerControlView : PlayerControlView)
    func playerControlView(_ playerControlView : PlayerControlView, didSlideSlider value : Float)
}

final class PlayerControlView: UIView {
    
    weak var delegate : PlayerControlViewDelegate?
    
    private var isPlaying = true

    private let volumeSlider : UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        return slider
    }()
    
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Cardigan"
        label.font = .systemFont(ofSize: 20, weight : .bold)
        return label
    }()
    
    private let artistLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Taylor Swift"
        label.font = .systemFont(ofSize: 18, weight : .semibold)
        return label
    }()
    
    private let backButton : UIButton = {
       let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "backward.fill",
                            withConfiguration: UIImage.SymbolConfiguration(
                                pointSize: 34,
                                weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let playPauseButton : UIButton = {
       let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "pause",
                            withConfiguration: UIImage.SymbolConfiguration(
                                pointSize: 34,
                                weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let forwardButton : UIButton = {
       let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "forward.fill",
                            withConfiguration: UIImage.SymbolConfiguration(
                                pointSize: 34,
                                weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(nameLabel)
        addSubview(artistLabel)
        addSubview(backButton)
        addSubview(playPauseButton)
        addSubview(forwardButton)
        addSubview(volumeSlider)
        
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapBackward), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(didTapForward), for: .touchUpInside)
        volumeSlider.addTarget(self, action: #selector(didSlideSlider), for: .valueChanged)
        
        clipsToBounds = true
    }
    
    @objc func didSlideSlider(_ slider : UISlider){
        let value = slider.value
        delegate?.playerControlView(self, didSlideSlider: value)
    }
    @objc func didTapPlayPause(){
        self.isPlaying.toggle()
        delegate?.didTapPlayPause(self)
        let pause = UIImage(systemName: "pause",
                            withConfiguration: UIImage.SymbolConfiguration(
                                pointSize: 34,
                                weight: .regular))
        let play = UIImage(systemName: "play.fill",
                            withConfiguration: UIImage.SymbolConfiguration(
                                pointSize: 34,
                                weight: .regular))
        playPauseButton.setImage(isPlaying ? pause : play, for: .normal)
    }
    @objc func didTapBackward(){
        delegate?.didTapBackward(self)
    }
    @objc func didTapForward(){
        delegate?.didTapForward(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with viewModel : PlayerControlViewModel){
        nameLabel.text = viewModel.songName
        artistLabel.text = viewModel.artistName
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.frame = CGRect(x: 10, y: 0, width: width - 20, height: 50)
        artistLabel.frame = CGRect(x: 10, y: nameLabel.bottom + 10, width: width - 20, height: 50)
        volumeSlider.frame = CGRect(x: 10, y: artistLabel.bottom + 10, width: width - 20, height: 44)
        let btnSize : CGFloat = 60
        playPauseButton.frame = CGRect(x: (width-btnSize)/2, y: volumeSlider.bottom + 30, width: btnSize, height: btnSize)
        backButton.frame = CGRect(x:playPauseButton.left - 50 - btnSize, y: playPauseButton.top , width: btnSize, height: btnSize)
        forwardButton.frame = CGRect(x:playPauseButton.right + 50, y: playPauseButton.top, width: btnSize, height: btnSize)
        
    }
}
