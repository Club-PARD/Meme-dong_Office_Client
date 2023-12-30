//
//  MainHomeViewController.swift
//  Think
//
//  Created by 김민섭 on 12/30/23.
//

import UIKit

class MainHomeViewController: UIViewController {

    let numberOfItemsPerRow = 6
    let numberOfRows = 4
    let cellReuseIdentifier = "collectionViewCell"
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        return collectionView
    }()
    
    private lazy var deskLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "교탁"  // 교탁에 표시할 텍스트
        label.textAlignment = .center
        label.backgroundColor = UIColor.brown // 교탁의 색상을 갈색으로 설정
        return label
    }()

    private lazy var teacherInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "교사: 김민섭 안녕하세요!"  // 교사 이름과 인사말을 설정
        label.textAlignment = .left
        label.numberOfLines = 0  // 여러 줄로 표시 가능하도록 설정
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        setupConstraints()
        setupDeskLabel()
        setupTeacherInfoLabel()
        setupLearnButton()
        setupLearnLabel()
    }

    private lazy var learnButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("학습하기", for: .normal)
        button.addTarget(self, action: #selector(learnButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var learnLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "학습하기"
        label.textAlignment = .center
        return label
    }()
    
    private func setupDeskLabel() {
        view.addSubview(deskLabel)
        
        NSLayoutConstraint.activate([
            deskLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deskLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            deskLabel.widthAnchor.constraint(equalToConstant: 93), // 교탁의 폭을 조절
            deskLabel.heightAnchor.constraint(equalToConstant: 40)  // 교탁의 높이를 조절
        ])
    }

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
    }

    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 60),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -20)
        ])
    }

    private func setupTeacherInfoLabel() {
        view.addSubview(teacherInfoLabel)
        
        NSLayoutConstraint.activate([
            teacherInfoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            teacherInfoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 200),
            teacherInfoLabel.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
    private func setupLearnButton() {
        view.addSubview(learnButton)
        
        NSLayoutConstraint.activate([
            learnButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70), // 화면(view)의 오른쪽에서 70만큼 떨어져 있도록 설정
            learnButton.centerYAnchor.constraint(equalTo: deskLabel.centerYAnchor), // 교탁의 세로 중앙에 위치하도록 설정
            learnButton.widthAnchor.constraint(equalToConstant: 80),
            learnButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    private func setupLearnLabel() {
        view.addSubview(learnLabel)
        
        NSLayoutConstraint.activate([
            learnLabel.centerXAnchor.constraint(equalTo: learnButton.centerXAnchor),
            learnLabel.topAnchor.constraint(equalTo: learnButton.bottomAnchor, constant: 5)
        ])
    }

    @objc private func learnButtonTapped() {
        print("학습하기 버튼이 탭되었습니다.")
        // 학습하기 버튼이 탭되었을 때 수행할 동작 구현
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewWillAppear(_ animated: Bool) {
        appDelegate.shouldSupportAllOrientation = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        appDelegate.shouldSupportAllOrientation = true
    }
}

extension MainHomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemsPerRow * numberOfRows
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        // Configure your cell here
        cell.backgroundColor = UIColor.systemGreen
        return cell
    }
}

extension MainHomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.width - CGFloat(numberOfItemsPerRow + 1) * 10) / CGFloat(numberOfItemsPerRow)
        let cellHeight: CGFloat = 40
        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension MainHomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        let button = UIButton(type: .system)
        button.setTitle("버튼", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        cell?.contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: cell!.contentView.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: cell!.contentView.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 80),
            button.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        UIView.animate(withDuration: 0.2, animations: {
            cell?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { (_) in
            UIView.animate(withDuration: 0.2, animations: {
                cell?.transform = CGAffineTransform.identity
            })
        }
    }

    @objc func buttonTapped() {
        print("셀과 버튼이 함께 탭되었습니다.")
    }
}
