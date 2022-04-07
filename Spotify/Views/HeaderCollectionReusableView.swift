//
//  PlaylistHeaderCollectionReusableView.swift
//  Spotify
//
//  Created by Truong Thinh on 06/04/2022.
//

import UIKit
import SDWebImage

protocol HeaderViewDelegate : AnyObject {
    func didTapPlayAll(_ header : HeaderCollectionReusableView )
}

class HeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "PlaylistHeaderCollectionReusableView"
    
    weak var delegate : HeaderViewDelegate?
    
    private let nameLabel : UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight : .semibold)
        return label
    }()
    
    private let descripstionLabel : UILabel = {
       let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight : .regular)
        return label
    }()
    private let ownerLabel : UILabel = {
       let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18, weight : .light)
        return label
    }()
    
    private let imageView : UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    private let playAllButton : UIButton = {
       let button = UIButton()
        button.backgroundColor = .systemGreen
        let image = UIImage(systemName: "play.fill",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.layer.masksToBounds =  true
        
        return button
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(descripstionLabel)
        addSubview(ownerLabel)
        addSubview(playAllButton)
        playAllButton.addTarget(self, action: #selector(didTapPlayAll), for: .touchUpInside)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize : CGFloat = height/1.8
        imageView.frame = CGRect(x: (width-imageSize)/2, y: 20, width: imageSize, height: imageSize)
        nameLabel.frame = CGRect(x: 10, y: imageView.bottom, width: width-20, height: 30)
        descripstionLabel.frame = CGRect(x: 10, y: nameLabel.bottom, width: width-20, height: 44)
        ownerLabel.frame = CGRect(x: 10, y: descripstionLabel.bottom, width: width-20, height: 44)
        
        playAllButton.frame = CGRect(x: width - 70, y: height - 70, width: 60, height: 60)
        
    }
    
    @objc func didTapPlayAll(){
        delegate?.didTapPlayAll(self)
    }
    func configure(with viewModel : HeaderViewModel){
        nameLabel.text = viewModel.name
        descripstionLabel.text = viewModel.description
        ownerLabel.text = viewModel.owner
        imageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
}
