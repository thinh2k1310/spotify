//
//  ProfileViewController.swift
//  Spotify
//
//  Created by Truong Thinh on 17/03/2022.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {

    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isHidden = true
        return tableView
    }()
    private var models : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        fetchProfile()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    private func fetchProfile(){
        APICaller.shared.getCurrentUserProfile{ [weak self] result in
            DispatchQueue.main.async {
                switch result{
                case .success(let userProfile) :
                    self?.updateUI(with: userProfile)
                case .failure(let error) :
                    print(error)
                    self?.failedToGetProfile()
                }
            }
        }
    }
    private func updateUI( with model : UserProfile){
        tableView.isHidden = false
        models.append("Full name: \(model.display_name)")
        models.append("Email: \(model.email)")
        models.append("Id: \(model.id)")
        models.append("Product: \(model.product.uppercased())")
        tableView.reloadData()
        self.createHeaderView(with: model.images[0].url)
    }
    private func failedToGetProfile(){
        let label = UILabel()
        label.text = "Failed to load profile"
        label.sizeToFit()
        label.textColor = .secondaryLabel
        view.addSubview(label)
        label.center = view.center
        
    }
    
    private func createHeaderView(with string : String?){
        guard let url = string, let urlImage = URL(string: url)  else {
            return
        }
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.height / 3))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: headerView.height * 0.75, height: headerView.height * 0.75))
        headerView.addSubview(imageView)
        imageView.center = headerView.center
        imageView.contentMode = .scaleAspectFill
        imageView.sd_setImage(with: urlImage, completed: nil)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.height/2
        tableView.tableHeaderView = headerView
    }

}
extension ProfileViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = models[indexPath.row]
        cell.textLabel?.textColor = .secondaryLabel
        return cell
    }
}
