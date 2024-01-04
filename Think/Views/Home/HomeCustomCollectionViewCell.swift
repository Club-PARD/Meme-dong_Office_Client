//
//  HomeCustomCollectionViewCell.swift
//  Think
//
//  Created by 이신원 on 1/4/24.
//
import UIKit

class HomeCustomCollectionViewCell:UICollectionViewCell {
    static let identifier = "homeCollectionViewCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.tintColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    let labelBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 255/255, green: 245/255, blue: 194/255, alpha: 1.0)
        view.layer.cornerRadius = 10
        return view
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(labelBackground)
        labelBackground.addSubview(nameLabel)
        
        contentView.backgroundColor = UIColor.clear
        contentView.layer.masksToBounds = true
        
        labelBackground.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelBackground.widthAnchor.constraint(equalToConstant: 75),
            labelBackground.heightAnchor.constraint(equalToConstant: 35),
            labelBackground.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelBackground.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: labelBackground.topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: labelBackground.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: labelBackground.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: labelBackground.trailingAnchor)
        ])
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with name: String) {
        nameLabel.text = name
    }
    
}

