//
//  CategoryViewController.swift
//  Spotify
//
//  Created by Truong Thinh on 08/04/2022.
//

import UIKit

class CategoryViewController: UIViewController {
    
    let category : Category

    private var playlists : [Playlist] = []
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.2),
                heightDimension: .fractionalHeight(1.2)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 7, bottom: 2, trailing: 7)
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(220)),
                subitem: item,
                count: 2
            )
            group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
            
            return NSCollectionLayoutSection(group: group)
        }))
    
    init(category : Category){
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = category.name
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.register(PlaylistCollectionViewCell.self, forCellWithReuseIdentifier: PlaylistCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
       
        APICaller.shared.getCategoryPlaylist(category: category) {[weak self]  result in
            DispatchQueue.main.async {
                switch result{
                case .success(let playlists):
                    self?.playlists = playlists
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
 
}

extension CategoryViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        playlists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PlaylistCollectionViewCell.identifier,
            for: indexPath) as? PlaylistCollectionViewCell else {
            return UICollectionViewCell()
        }
        let playlist = playlists[indexPath.row]
        let viewModel = PlaylistCellViewModel(
            name: playlist.name ,
            artworkURL: URL(string: playlist.images.first?.url ?? ""),
            creatorName: playlist.owner.display_name)
        cell.configure(with: viewModel)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let playlist = playlists[indexPath.row]
        let vc = PlaylistViewController(playlist: playlist)
        vc.title = playlist.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true )
    }
}
