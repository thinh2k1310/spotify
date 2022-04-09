//
//  SearchResultTableViewCell.swift
//  Spotify
//
//  Created by Truong Thinh on 09/04/2022.
//

import Foundation

import UIKit
import SDWebImage


class SearchResultTableViewCell: UITableViewCell {
    
    static let identifier = "SearchResultTableViewCell"
    
    private let label : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight : .semibold)
        label.textColor = .white
        return label
    }()
    
    private let subLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 15, weight : .light)
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
        contentView.addSubview(subLabel)
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
        label.frame = CGRect(x: iconImageView.right + 10, y: 0 ,
                             width: contentView.width - iconImageView.width - 15,
                             height: contentView.height * 0.6)
        subLabel.frame = CGRect(x: iconImageView.right + 10, y: label.bottom,
                                width: contentView.width - iconImageView.width - 15,
                                height:contentView.height * 0.4)
    }
    
    override func prepareForReuse() {
        iconImageView.image = nil
        label.text = nil
        subLabel.text = nil
    }
    
    func configure(with viewModel : SearchResultTableViewCellViewModel){
        label.text = viewModel.title
        subLabel.text = viewModel.subTitle
        if viewModel.artworkURL?.absoluteString == "" || viewModel.artworkURL == nil{
            iconImageView.image = UIImage(systemName : "questionmark")
        }
        else {
            
            iconImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        }
    }

}
