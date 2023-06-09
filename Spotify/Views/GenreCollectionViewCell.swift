//
//  CategoryCollectionViewCell.swift
//  Spotify
//
//  Created by Teenu Abraham on 13/03/23.
//

import UIKit
import SDWebImage

class CategoryCollectionViewCell: UICollectionViewCell {
   static let identifier = "CategoryCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.image = UIImage(
            systemName: "music.quarternote.3",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 50, weight: .regular
            )
        )
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let  colors: [UIColor] = [
        .systemPurple,
        .systemPink,
        .systemBlue,
        .systemTeal,
        .systemBrown,
        .systemGreen,
        .systemGray,
        .red,
        .purple,
        .orange
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.addSubview(imageView)
        contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        imageView.image = UIImage(
            systemName: "music.quarternote.3",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 50, weight: .regular
            )
        )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(
            x: 10,
            y: (contentView.height/2),
            width: contentView.width - 15,
            height: contentView.height/2
        )
        
        imageView.frame =  CGRect(
            x: contentView.width/2,
            y: 10,
            width: (contentView.width/2) - 20,
            height: (contentView.width/2) - 20
        )
    }
    
    func configure(with viewModel: CategoryCollectionViewCellViewModel){
        label.text = viewModel.title
        imageView.sd_setImage(
            with: viewModel.artworkURL,
            completed: nil
        )
        contentView.backgroundColor = colors.randomElement()
    }
}
