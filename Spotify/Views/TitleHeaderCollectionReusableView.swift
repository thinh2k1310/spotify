//
//  TitleHeaderCollectionReusableView.swift
//  Spotify
//
//  Created by Truong Thinh on 07/04/2022.
//

import UIKit

class TitleHeaderCollectionReusableView: UICollectionReusableView {
 
    static let identifier = "TitleHeaderCollectionReusableView"
    
    private let titleLabel : UILabel = {
       let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 25, weight : .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 10, y: 0, width: width - 20, height: height)
    }
    func configure(with title : String){
        titleLabel.text = title
    }
}
