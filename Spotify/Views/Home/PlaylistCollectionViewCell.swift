//
//  FeaturedPlaylistCollectionViewCell.swift
//  Spotify
//
//  Created by Truong Thinh on 22/03/2022.
//

import UIKit

class PlaylistCollectionViewCell: UICollectionViewCell {
    static let identifier = "PlaylistCollectionViewCell"
    
    private let playlistCoverImageView : UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
//    private let playlistNameLabel : UILabel = {
//       let label = UILabel()
//        label.font = .systemFont(ofSize: 22, weight: .semibold)
//        label.numberOfLines = 2
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.adjustsFontSizeToFitWidth = true
//        label.minimumScaleFactor = 0.5
//        return label
//    }()
    private let creatorNameLabel : UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 18 , weight : .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(playlistCoverImageView)
        //contentView.addSubview(playlistNameLabel)
        contentView.addSubview(creatorNameLabel)
        contentView.clipsToBounds = true
        applyConstraints()
    }
    
    required init?(coder: NSCoder){
        fatalError()
    }
    private func applyConstraints() {
        let playlistCoverImageViewConstraints = [
            playlistCoverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            playlistCoverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 5),
            playlistCoverImageView.widthAnchor.constraint(equalToConstant: contentView.width - 10 ),
            playlistCoverImageView.heightAnchor.constraint(equalToConstant: contentView.width - 10)
        ]
//        let playlistNameLabelConstraints = [
//            playlistNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 5),
//            playlistNameLabel.leadingAnchor.constraint(equalTo: playlistCoverImageView.trailingAnchor,constant: 5),
//            playlistNameLabel.widthAnchor.constraint(equalToConstant: contentView.width * 0.6)
//        ]
        let creatorNameLabelConstraints = [
            creatorNameLabel.topAnchor.constraint(equalTo: playlistCoverImageView.bottomAnchor,constant: 5),
            creatorNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ]
        NSLayoutConstraint.activate(playlistCoverImageViewConstraints)
        //NSLayoutConstraint.activate(playlistNameLabelConstraints)
        NSLayoutConstraint.activate(creatorNameLabelConstraints)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        //playlistNameLabel.text = nil
        creatorNameLabel.text = nil
        playlistCoverImageView.image = nil
    }
    func configure(with viewModel : PlaylistCellViewModel){
        //playlistNameLabel.text = viewModel.name
        creatorNameLabel.text = viewModel.creatorName
        playlistCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        
    }
}
