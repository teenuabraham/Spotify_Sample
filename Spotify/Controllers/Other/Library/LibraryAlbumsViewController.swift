//
//  LibraryAlbumsViewController.swift
//  Spotify
//
//  Created by Teenu Abraham on 20/03/23.
//

import UIKit

class LibraryAlbumsViewController: UIViewController {
    
    var albums = [Album]()
    
    private let noAlbumssView =  ActionLabelView()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(
            SearchResultsSubtitleTableViewCell.self,
            forCellReuseIdentifier: SearchResultsSubtitleTableViewCell.identifier
        )
        tableView.isHidden = true
        return tableView
    }()
    
    private var observer: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        setUpNoAlbumsView()
        fetchData()
        observer = NotificationCenter.default.addObserver(
            forName: .albumSavedNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                self?.fetchData()
            })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noAlbumssView.frame = CGRect(
            x: (view.width-150)/2,
            y: (view.height-150)/2,
            width: 150,
            height: 150
        )
     //   noAlbumssView.center = view.center
      //  tableView.frame = view.bounds
        tableView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
    }
    
    private func setUpNoAlbumsView(){
        view.addSubview(noAlbumssView)
        noAlbumssView.delegate = self
        noAlbumssView.configure(with: ActionLabelViewViewModel(
            text: "You have not saved any albums yet",
            actionTitle: "Browse"
        )
        )
    }
    
    private func fetchData(){
        albums.removeAll()
        APICaller.shared.getCurrentUserAlbums { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let albums):
                    self?.albums = albums
                    self?.updateUI()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
 

    private func updateUI() {
        if albums.isEmpty {
            // Show label
            noAlbumssView.isHidden = false
            tableView.isHidden = true
        }
        else {
            tableView.reloadData()
            noAlbumssView.isHidden = true
            tableView.isHidden = false
        }
    }
}

extension LibraryAlbumsViewController: ActionLabelViewDelegate {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        tabBarController?.selectedIndex = 0
    }
}

extension LibraryAlbumsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultsSubtitleTableViewCell.identifier,
            for: indexPath
        ) as? SearchResultsSubtitleTableViewCell else {
            return UITableViewCell()
        }
        let album = albums[indexPath.row]
        cell.configure(with: SearchResultsSubtitleTableViewCellViewModel(
            title: album.name,
            subtitle: album.artists.first?.name ?? "",
            imageURL: URL(string: album.images.first?.url ?? "")
        ))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        let album = albums[indexPath.row]
        let vc = AlbumViewController(album: album)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
