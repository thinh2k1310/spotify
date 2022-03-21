//
//  SettingsViewController.swift
//  Spotify
//
//  Created by Truong Thinh on 17/03/2022.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private let tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
        
    }()
    private var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        configureSections()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    private func configureSections(){
        sections.append(Section(title: "Profile", options: [Option(title: "View your profile", handler: {[weak self] in
            DispatchQueue.main.async {
                self?.viewProfile()
            }
        })]))
        sections.append(Section(title: "Account", options: [Option(title: "Sign Out", handler: {[weak self] in
            DispatchQueue.main.async {
                self?.signOut()
            }
        })]))
    }
    private func viewProfile(){
        let vc = ProfileViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = "Profile"
        navigationController?.pushViewController(vc, animated: true)
    }
    private func signOut(){
        
    }
}
extension SettingsViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = sections[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = option.title
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = sections[indexPath.section].options[indexPath.row]
        option.handler()
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = sections[section]
        return section.title
    }
    
}
