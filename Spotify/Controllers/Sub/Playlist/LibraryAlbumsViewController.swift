//
//  LibraryAlbumsViewController.swift
//  Spotify
//
//  Created by Truong Thinh on 11/04/2022.
//

import UIKit

class LibraryAlbumsViewController: UIViewController {

    var albums : [Album] = []
    
    private let noAlbumsView = ActionAlertView()
    
    private let tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SearchResultTableViewCell.self,
                           forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
        
    }()
    
    private var observer : NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =  .systemBackground
        
        setUpNoAlbumsView()
        fetchData()
        noAlbumsView.delegate = self
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        observer = NotificationCenter.default.addObserver(
            forName: .albumSavedNotification,
            object: nil,
            queue: .main,
            using: {[weak self] _ in
                self?.fetchData()
        })
        
    }

    
    private func setUpNoAlbumsView(){
        view.addSubview(noAlbumsView)
        
        noAlbumsView.configure(with: ActionAlertViewModel(text: "You don't save any albums yet.",
                                                             actionTitle: "Go to Home"))
    }
    
    private func fetchData(){
        albums.removeAll()
        APICaller.shared.getCurrentUserAlbums { [weak self] result in
            DispatchQueue.main.async {
                switch result{
                case .success(let albums) :
                    self?.albums = albums
                    self?.updateUI()
                case.failure(let error):
                    print(error)
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noAlbumsView.frame = CGRect(x: (view.width-150)/2, y: (view.height-150)/2, width: 150, height: 150)
        tableView.frame = view.bounds
    }
    
    private func updateUI(){
        if albums.isEmpty{
            noAlbumsView.isHidden = false
            tableView.isHidden = true
        }
        else{
            tableView.reloadData()
            noAlbumsView.isHidden = true
            tableView.isHidden = false
        }
    }
    
}

extension LibraryAlbumsViewController : ActionAlertViewDelegate {
    func actionAlertViewDelegateDidTapButton(_ actionView: ActionAlertView) {
        //showCreatePlaylistAlert()
        tabBarController?.selectedIndex = 0
    }
}

extension LibraryAlbumsViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath) as? SearchResultTableViewCell else {
            return UITableViewCell()
        }
        let album = albums[indexPath.row]
        cell.configure(with: SearchResultTableViewCellViewModel(
            title: album.name,
            subTitle: album.artists.first?.name ?? "",
            artworkURL: URL(string:album.images.first?.url ?? "")))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSeletion()
        let album = albums[indexPath.row]
        let vc = AlbumViewController(album: album)
        vc.navigationItem.largeTitleDisplayMode = .never
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
