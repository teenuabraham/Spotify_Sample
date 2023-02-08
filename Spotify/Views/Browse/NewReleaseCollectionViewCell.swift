//
//  NewReleaseCollectionViewCell.swift
//  Spotify
//
//  Created by Teenu Abraham on 07/03/23.
//

import UIKit
import SDWebImage


class NewReleaseCollectionViewCell: UICollectionViewCell {
  static let identifier = "NewReleaseCollectionViewCell"
    
    private let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .semibold)
      return label
    }()
    
    private let numberOfTrackLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .thin)
      return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .light)
      return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(numberOfTrackLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder){
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.height - 10
        let albumLabelSize = albumNameLabel.sizeThatFits(
            CGSize(
                width: contentView.width - imageSize - 10,
                height: contentView.height - 10
            )
        )
        let albumLabelHeight = min(60,albumLabelSize.height)
        artistNameLabel.sizeToFit()
        numberOfTrackLabel.sizeToFit()
        
        albumCoverImageView.frame = CGRect(
            x: 5,
            y: 5,
            width: imageSize,
            height: imageSize
        )
        
        albumNameLabel.frame = CGRect(
            x: albumCoverImageView.right + 10,
            y: 5,
            width: albumLabelSize.width,
            height: albumLabelHeight
        )
        
        artistNameLabel.frame = CGRect(
            x: albumCoverImageView.right + 10,
            y: albumLabelHeight + 5,
            width: contentView.width - albumCoverImageView.right - 10,
            height: 30
        )
        
        numberOfTrackLabel.frame = CGRect(
            x: albumCoverImageView.right + 10,
            y: contentView.bottom - 44,
            width: numberOfTrackLabel.width,
            height: 44
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        numberOfTrackLabel.text = nil
        albumCoverImageView.image = nil
    }
    func configure(with viewModel: NewReleasesCellViewModel ){
        albumNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        numberOfTrackLabel.text = "Tracks: \(viewModel.mumberOfTracks)"
        albumCoverImageView.sd_setImage(with: viewModel.artworkUrl,completed: nil)
    }
}
