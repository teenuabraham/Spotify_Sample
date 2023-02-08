//
//  LibraryToggleView.swift
//  Spotify
//
//  Created by Teenu Abraham on 20/03/23.
//

import UIKit

protocol LibraryToggleViewDelegate: AnyObject{
    func libraryToggleViewDidTapPlaylist(_ toggleView: LibraryToggleView)
    func libraryToggleViewDidTapAlbums(_ toggleView: LibraryToggleView)
}

class LibraryToggleView: UIView {

    enum State {
        case playlist
        case album
    }
    
    var state: State = .playlist
    
    weak var delegate: LibraryToggleViewDelegate?
    
    private let playlistButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Playlists", for: .normal)
        return button
    }()
    
    private let albumsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Albums", for: .normal)
        return button
    }()
    
    private let indicatorView: UIView = {
       let view = UIView()
        view.backgroundColor = .green
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(playlistButton)
        addSubview(albumsButton)
        addSubview(indicatorView)
        playlistButton.addTarget(self, action: #selector(didTapPlaylists), for: .touchUpInside)
        albumsButton.addTarget(self, action: #selector(didTapAlbums), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapPlaylists() {
        state = .playlist
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
        delegate?.libraryToggleViewDidTapPlaylist(self)
    }
    
    @objc private func didTapAlbums() {
        state = .album
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
        delegate?.libraryToggleViewDidTapAlbums(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playlistButton.frame = CGRect(
            x: 0,
            y: 0,
            width: 100,
            height: 40
        )
        albumsButton.frame = CGRect(
            x: playlistButton.right,
            y: 0,
            width: 100,
            height: 40
        )
        layoutIndicator()
    }
    
    func layoutIndicator(){
        switch state {
        case .playlist:
            indicatorView.frame = CGRect(
                x: 0,
                y: playlistButton.bottom,
                width: 100,
                height: 3
            )
        case .album:
            indicatorView.frame = CGRect(
                x: 100,
                y: playlistButton.bottom,
                width: 100,
                height: 3
            )
        }
    }
    
    func update(for state: State){
        self.state = state
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
    }
}
