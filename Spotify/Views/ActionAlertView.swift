//
//  ActionAlertView.swift
//  Spotify
//
//  Created by Truong Thinh on 12/04/2022.
//

import UIKit

struct ActionAlertViewModel{
    let text : String
    let actionTitle : String
}

protocol ActionAlertViewDelegate : AnyObject{
    func actionAlertViewDelegateDidTapButton(_ actionView : ActionAlertView)
}

class ActionAlertView: UIView {
    
    weak var delegate : ActionAlertViewDelegate?
    
    private let label : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight : .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let button : UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        addSubview(button)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = CGRect(x: 0, y: 0, width: width, height: 40)
        label.frame = CGRect(x: 0, y: 0, width: width, height: height-45)
    }
    
    func configure(with viewModel : ActionAlertViewModel){
        label.text = viewModel.text
        button.setTitle(viewModel.actionTitle, for: .normal )
    }
    @objc func didTapButton(){
        delegate?.actionAlertViewDelegateDidTapButton(self)
    }

}
