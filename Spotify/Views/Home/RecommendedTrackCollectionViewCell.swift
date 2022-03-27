//
//  RecommendedTrackCollectionViewCell.swift
//  Spotify
//
//  Created by Truong Thinh on 22/03/2022.
//

import UIKit

class RecommendedTrackCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecommendedTrackCollectionViewCell"
    
    private let trackCoverImageView : UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let trackNameLabel : UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let artistNameLabel : UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 18 , weight : .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(trackCoverImageView)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
        applyConstraints()
    }
    
    required init?(coder: NSCoder){
        fatalError()
    }
    private func applyConstraints() {
        let trackCoverImageViewConstraints = [
            trackCoverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            trackCoverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 5),
            trackCoverImageView.widthAnchor.constraint(equalToConstant: contentView.height - 10 ),
            trackCoverImageView.heightAnchor.constraint(equalToConstant: contentView.height - 10)
        ]
        let trackNameLabelConstraints = [
            trackNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 5),
            trackNameLabel.leadingAnchor.constraint(equalTo: trackCoverImageView.trailingAnchor,constant: 5),
            trackNameLabel.widthAnchor.constraint(equalToConstant: contentView.width * 0.7)
        ]
        let artistNameLabelConstraints = [
            artistNameLabel.topAnchor.constraint(equalTo: trackNameLabel.bottomAnchor,constant: 5),
            artistNameLabel.leadingAnchor.constraint(equalTo: trackCoverImageView.trailingAnchor,constant: 5)
        ]
        NSLayoutConstraint.activate(trackCoverImageViewConstraints)
        NSLayoutConstraint.activate(trackNameLabelConstraints)
        NSLayoutConstraint.activate(artistNameLabelConstraints)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = nil
        artistNameLabel.text = nil
        trackCoverImageView.image = nil
    }
    func configure(with viewModel : RecommendedTrackCellViewModel){
        trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        trackCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        
    }
}
