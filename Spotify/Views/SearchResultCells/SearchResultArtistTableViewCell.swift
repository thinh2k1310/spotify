//
//  SearchResultDefaultTableViewCell.swift
//  Spotify
//
//  Created by Truong Thinh on 09/04/2022.
//

import UIKit
import SDWebImage


class SearchResultArtistTableViewCell: UITableViewCell {
    
    static let identifier = "SearchResultArtistTableViewCell"
    
    private let label : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 22, weight : .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let iconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style : UITableViewCell.CellStyle , reuseIdentifier: String? ){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(iconImageView)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize = contentView.height - 10
        iconImageView.frame = CGRect(x: 10, y: 5, width: imageSize, height: imageSize)
        iconImageView.layer.cornerRadius =  imageSize/2
        iconImageView.layer.masksToBounds =  true
        label.frame = CGRect(x: iconImageView.right + 10, y: 0 ,
                             width: contentView.width - iconImageView.width - 15,
                             height: contentView.height)
    }
    
    override func prepareForReuse() {
        iconImageView.image = nil
        label.text = nil
    }
    
    func configure(with viewModel : SearchResultArtistTableViewCellViewModel){
        label.text = viewModel.title
        if viewModel.artworkURL?.absoluteString == "" || viewModel.artworkURL == nil{
            iconImageView.image = UIImage(systemName : "person.fill.questionmark")
        }
        else {
            
            iconImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        }
    }

}
