//
//  AlbumViewController.swift
//  Spotify
//
//  Created by Truong Thinh on 30/03/2022.
//

import UIKit

class AlbumViewController: UIViewController {
    
    private let album : Album

    private var viewModels = [TrackCellViewModel]()
    private var tracks = [AudioTrack]()
    
    
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
    
    init(album : Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = album.name
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
        
        fetchData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(didTapAction))
        
    }
    
    @objc func didTapAction(){
        let actionSheet = UIAlertController(title: album.name, message: "Saved this album", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Save", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {
                return
            }
            APICaller.shared.saveAlbum(album: strongSelf.album) { success in
                NotificationCenter.default.post(name: .albumSavedNotification, object: nil)
            }
        }))
        present(actionSheet, animated: true)
    }
    
    private func fetchData(){
        APICaller.shared.getAlbumDetail(album: album) { [weak self] result in
            DispatchQueue.main.async {
                switch result{
                case  .success(let model):
                    self?.tracks = model.tracks.items
                    self?.viewModels = model.tracks.items.compactMap({
                        TrackCellViewModel(
                            name: $0.name,
                            artistName: $0.artists.first?.name ?? "-",
                            artworkURL: URL(string: self?.album.images.first?.url ?? "" ))
                    })
                        self?.collectionView.reloadData()
                case  .failure(let error):
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

extension AlbumViewController : UICollectionViewDelegate, UICollectionViewDataSource {
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
        let albumHeaderVM =  HeaderViewModel(
            name: album.name,
            artworkURL: URL(string: album.images.first?.url ?? "" ),
            description: "Realease Date: \(String.formattedDate(string: album.release_date))",
            owner: album.artists.first?.name )
        header.delegate = self
        header.configure(with: albumHeaderVM)
        return header
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        var track = tracks[indexPath.row]
        track.album = self.album
        PlaybackPresenter.shared.startPlayback(from: self, track: track)
    }
}

extension AlbumViewController : HeaderViewDelegate{
    func didTapPlayAll(_ header: HeaderCollectionReusableView) {
        let tracksWithAlbum : [AudioTrack] = tracks.compactMap({
            var track = $0
            track.album = self.album
            return track
        })
        PlaybackPresenter.shared.startPlayback(from: self, tracks: tracksWithAlbum)
    }
}



