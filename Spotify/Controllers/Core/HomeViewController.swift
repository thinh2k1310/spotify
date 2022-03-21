//
//  ViewController.swift
//  Spotify
//
//  Created by Truong Thinh on 17/03/2022.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSettings))
    }
    
    @objc func didTapSettings(){
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }


}

