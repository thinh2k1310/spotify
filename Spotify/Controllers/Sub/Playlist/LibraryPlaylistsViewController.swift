//
//  LibraryPlaylistViewController.swift
//  Spotify
//
//  Created by Truong Thinh on 11/04/2022.
//

import UIKit

class LibraryPlaylistViewController: UIViewController {

    var playlists : [Playlist] = []
    
    public var selectionHandler : ((Playlist) -> Void)?
    
    private let noPlaylistsView = ActionAlertView()
    
    private let tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SearchResultTableViewCell.self,
                           forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =  .systemBackground
        
        setUpNoPlaylistsView()
        fetchData()
        noPlaylistsView.delegate = self
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        if selectionHandler != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target:self, action: #selector(didTapClose))
        }
    }
    
    @objc func didTapClose(){
        dismiss(animated: true, completion: nil)
    }
    
    private func setUpNoPlaylistsView(){
        view.addSubview(noPlaylistsView)
        
        noPlaylistsView.configure(with: ActionAlertViewModel(text: "You don't have any playlists yet.",
                                                             actionTitle: "Create"))
    }
    
    private func fetchData(){
        APICaller.shared.getCurrentUserPlaylist { [weak self] result in
            DispatchQueue.main.async {
                switch result{
                case .success(let playlists) :
                    self?.playlists = playlists
                    self?.updateUI()
                case.failure(let error):
                    print(error)
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noPlaylistsView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        noPlaylistsView.center = view.center
        tableView.frame = view.bounds
    }
    
    private func updateUI(){
        if playlists.isEmpty{
            noPlaylistsView.isHidden = false
            tableView.isHidden = true
        }
        else{
            tableView.reloadData()
            noPlaylistsView.isHidden = true
            tableView.isHidden = false
        }
    }
    func showCreatePlaylistAlert(){
        let alert = UIAlertController(
            title: "New Playlist",
            message: "Enter playlist name",
            preferredStyle: .alert)
        alert.addTextField { textfield in
            textfield.placeholder = "playlist..."
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
            guard let field = alert.textFields?.first,
                  let text = field.text,
            !text.trimmingCharacters(in: .whitespaces).isEmpty else{
                      return
                  }
            APICaller.shared.createPlaylist(with: text) {[weak self] success in
                if success {
                    HapticsManager.shared.vibrate(for: .success)
                    self?.updateUI()
                }
                else{
                    HapticsManager.shared.vibrate(for: .error)
                    print("Failed to create playlist.")
                }
            }
        }))
        present(alert, animated: true)
    }
}

extension LibraryPlaylistViewController : ActionAlertViewDelegate {
    func actionAlertViewDelegateDidTapButton(_ actionView: ActionAlertView) {
        showCreatePlaylistAlert()
    }
}

extension LibraryPlaylistViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath) as? SearchResultTableViewCell else {
            return UITableViewCell()
        }
        let playlist = playlists[indexPath.row]
        cell.configure(with: SearchResultTableViewCellViewModel(
            title: playlist.name,
            subTitle: playlist.owner.display_name,
            artworkURL: URL(string:playlist.images.first?.url ?? "")))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSeletion()
        let playlist = playlists[indexPath.row]
        guard selectionHandler == nil else {
            selectionHandler?(playlist)
            dismiss(animated: true, completion: nil)
            return
        }
        let vc = PlaylistViewController(playlist: playlists[indexPath.row])
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.isOwner = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
