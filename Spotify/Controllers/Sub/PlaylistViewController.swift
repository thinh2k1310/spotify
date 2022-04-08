//
//  PlaylistViewController.swift
//  Spotify
//
//  Created by Truong Thinh on 17/03/2022.
//

import UIKit

class PlaylistViewController: UIViewController {

    private let playlist : Playlist
    private var viewModels = [TrackCellViewModel]()
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0))
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 2, bottom: 1, trailing: 2)
            //Group
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60)),
                subitem: item,
                count: 1)
            
            //Section
            let section = NSCollectionLayoutSection(group: group )
            section.boundarySupplementaryItems = [
                NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalWidth(1.0)),
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)
            ]
            return section
        }))
    
    init(playlist : Playlist) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = playlist.name
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(HeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderCollectionReusableView.identifier)
        collectionView.register(TrackCollectionViewCell.self,
                                forCellWithReuseIdentifier: TrackCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self

        APICaller.shared.getPlaylistDetail(playlist: playlist) { [weak self] result in
            DispatchQueue.main.async {
                switch result{
                case  .success(let model):
                    self?.viewModels = model.tracks.items.compactMap({
                        TrackCellViewModel(
                            name: $0.track.name,
                            artistName: $0.track.artists.first?.name ?? "-",
                            artworkURL: URL(string: $0.track.album?.images.first?.url ?? ""))
                    })
                        self?.collectionView.reloadData()
                case  .failure(let error):
                    print(error)
                }
            }
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(didTapShare))
    }
   
    @objc func didTapShare(){
        guard let url = URL(string: playlist.external_urls["spotify"] ?? "") else {
            return
        }
        let vc = UIActivityViewController(activityItems: [url],
                                          applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc,animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

extension PlaylistViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModels.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackCollectionViewCell.identifier,
            for: indexPath) as? TrackCollectionViewCell else {
                return UICollectionViewCell()
            }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader ,
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: HeaderCollectionReusableView.identifier,
            for: indexPath) as? HeaderCollectionReusableView else {
                return UICollectionReusableView()
            }
        let playlistHeaderVM =  HeaderViewModel(
            name: playlist.name,
            artworkURL: URL(string: playlist.images.first?.url ?? "" ),
            description: playlist.description ,
            owner: playlist.owner.display_name )
        header.configure(with: playlistHeaderVM)
        header.delegate = self
        return header
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    
}

extension PlaylistViewController : HeaderViewDelegate{
    func didTapPlayAll(_ header: HeaderCollectionReusableView) {
        print("playing all")
    }
}
