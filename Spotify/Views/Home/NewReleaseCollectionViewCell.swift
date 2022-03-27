//
//  NewReleaseCollectionViewCell.swift
//  Spotify
//
//  Created by Truong Thinh on 22/03/2022.
//

import UIKit
import SDWebImage

class NewReleaseCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewReleaseCollectionViewCell"
    
    private let albumCoverImageView : UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let albumNameLabel : UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    private let numberOfTracksLabel : UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 18 , weight : .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let artistNameLabel : UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 18 , weight : .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(numberOfTracksLabel)
        contentView.clipsToBounds = true
        applyConstraints()
    }
    
    required init?(coder: NSCoder){
        fatalError()
    }
    private func applyConstraints() {
        let albumCoverImageViewConstraints = [
            albumCoverImageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 5),
            albumCoverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 5),
            albumCoverImageView.widthAnchor.constraint(equalToConstant: contentView.height-10),
            albumCoverImageView.heightAnchor.constraint(equalToConstant: contentView.height-10)
        ]
        let albumNameLabelConstraints = [
            albumNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 5),
            albumNameLabel.leadingAnchor.constraint(equalTo: albumCoverImageView.trailingAnchor,constant: 5),
            albumNameLabel.widthAnchor.constraint(equalToConstant: contentView.width * 0.6)
        ]
        let artistNameLabelConstraints = [
            artistNameLabel.topAnchor.constraint(equalTo: albumNameLabel.bottomAnchor,constant: 5),
            artistNameLabel.leadingAnchor.constraint(equalTo: albumCoverImageView.trailingAnchor,constant: 5)
        ]
        let numberOfTracksLabel = [
            numberOfTracksLabel.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor,constant: 5),
            numberOfTracksLabel.leadingAnchor.constraint(equalTo: albumCoverImageView.trailingAnchor,constant: 5)
        ]
        NSLayoutConstraint.activate(albumCoverImageViewConstraints)
        NSLayoutConstraint.activate(albumNameLabelConstraints)
        NSLayoutConstraint.activate(artistNameLabelConstraints)
        NSLayoutConstraint.activate(numberOfTracksLabel)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        numberOfTracksLabel.text = nil
        albumCoverImageView.image = nil
    }
    func configure(with viewModel : NewReleasesCellViewModel){
        albumNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        numberOfTracksLabel.text = ("Total track : \(viewModel.numberOfTracks)")
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        
    }
}
