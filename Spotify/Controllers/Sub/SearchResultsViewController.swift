//
//  SearchResultsViewController.swift
//  Spotify
//
//  Created by Truong Thinh on 17/03/2022.
//

import UIKit
struct SearchSection{
    let title : String
    let results : [SearchResult]
}

protocol SearchResultsViewControllerDelegate : AnyObject{
    func didTapResult(_ result : SearchResult)
}

class SearchResultsViewController: UIViewController {
    
    weak var delegate : SearchResultsViewControllerDelegate?

    private var sections : [SearchSection] = []
    
    private let tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SearchResultArtistTableViewCell.self,
                           forCellReuseIdentifier: SearchResultArtistTableViewCell.identifier)
        tableView.register(SearchResultTableViewCell.self,
                           forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isHidden = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func update(with results : [SearchResult]){
        let artists = results.filter({
            switch $0{
            case .artist:
                return true
            default:
                return false
            }
        })
        let tracks = results.filter({
            switch $0{
            case .track:
                return true
            default:
                return false
            }
        })
        let albums = results.filter({
            switch $0{
            case .album:
                return true
            default:
                return false
            }
        })
        let playlist = results.filter({
            switch $0{
            case .playlist:
                return true
            default:
                return false
            }
        })
        
        sections = [SearchSection(title: "artists", results: artists ),
                    SearchSection(title: "tracks", results: tracks ),
                    SearchSection(title: "albums", results: albums ),
                    SearchSection(title: "playlist", results: playlist )]
        tableView.reloadData()
        tableView.isHidden = results.isEmpty
    }
       
}

extension SearchResultsViewController : UITableViewDataSource,UITableViewDelegate{
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].results.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = sections[indexPath.section].results[indexPath.row]
        switch result{
        case .album(let album):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultTableViewCell.identifier,
                for: indexPath) as? SearchResultTableViewCell else{
                    return UITableViewCell()
                }
            let albumViewModel = SearchResultTableViewCellViewModel(
                title: album.name,
                subTitle: album.artists.first?.name ?? "",
                artworkURL: URL(string: album.images.first?.url ?? ""))
            cell.configure(with: albumViewModel)
            return cell
        case .artist(let artist):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultArtistTableViewCell.identifier,
                for: indexPath) as? SearchResultArtistTableViewCell else{
                    return UITableViewCell()
                }
            let artistViewModel = SearchResultArtistTableViewCellViewModel(
                title: artist.name,
                artworkURL: URL(string: artist.images?.first?.url ?? ""))
            cell.configure(with: artistViewModel)
            return cell
        case .track(let track):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultTableViewCell.identifier,
                for: indexPath) as? SearchResultTableViewCell else{
                    return UITableViewCell()
                }
            let trackViewModel = SearchResultTableViewCellViewModel(
                title: track.name,
                subTitle: track.artists.first?.name ?? "",
                artworkURL: URL(string: track.album?.images.first?.url ?? ""))
            cell.configure(with: trackViewModel)
            return cell
        case .playlist(let playlist):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultTableViewCell.identifier,
                for: indexPath) as? SearchResultTableViewCell else{
                    return UITableViewCell()
                }
            let playlistViewModel = SearchResultTableViewCellViewModel(
                title: playlist.name,
                subTitle: playlist.owner.display_name,
                artworkURL: URL(string: playlist.images.first?.url ?? ""))
            cell.configure(with: playlistViewModel)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let result = sections[indexPath.section].results[indexPath.row]
        delegate?.didTapResult(result)
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
}
