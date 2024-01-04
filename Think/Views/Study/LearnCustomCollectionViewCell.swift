//
//  LearnCustomCollectionViewCell.swift
//  study
//
//  Created by 이신원 on 1/2/24.
//

import UIKit


class LearnCustomCollectionViewCell: UICollectionViewCell{
    static let identifier = "learnCollectionViewCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.tintColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    let labelBackgroundWhite: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 3
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(labelBackgroundWhite)
        labelBackgroundWhite.addSubview(nameLabel)
        
        // 여기에서만 contentView의 배경색을 설정합니다.
        contentView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        labelBackgroundWhite.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelBackgroundWhite.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
            labelBackgroundWhite.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3),
            labelBackgroundWhite.heightAnchor.constraint(equalToConstant: contentView.frame.height - 30),
            labelBackgroundWhite.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: labelBackgroundWhite.topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: labelBackgroundWhite.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: labelBackgroundWhite.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: labelBackgroundWhite.trailingAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with name: String) {
        nameLabel.text = name
        // 여기에서 nameLabel의 배경색을 투명하게 설정하여 contentView의 색상이 보이도록 합니다.
        nameLabel.backgroundColor = .clear
    }
    
    func updateLabel(name:String){
        nameLabel.text = name
    }
    
    func updateBackground(color:UIColor){
        contentView.backgroundColor = color
    }
    
    

    
}
