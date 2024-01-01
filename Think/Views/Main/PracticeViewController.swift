//
//  PracticeViewController.swift
//  Think
//
//  Created by 김민섭 on 1/1/24.
//

import UIKit

class PracticeViewController: UIViewController {

    private var collectionView: UICollectionView!
    private let reuseIdentifier = "cell"
    private var rows = 5 // 행 수
    private var columns = 4 // 열 수

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = createLayout()

        // UICollectionView 생성
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.register(MyButtonCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.dataSource = self

        view.addSubview(collectionView)
    }

    private func createLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 10.0 // 셀과 셀 간격

        return UICollectionViewCompositionalLayout { (section, environment) -> NSCollectionLayoutSection? in
            // 섹션에 대한 레이아웃 정의
            // 예: 그리드로 배치된 아이템들
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / CGFloat(self.columns)), heightDimension: .fractionalHeight(0.10 / CGFloat(self.rows))))
            item.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)

            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0 / CGFloat(self.rows))), subitem: item, count: self.columns)

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)

            return section
        }
    }


    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //가로모드 적용
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.shouldSupportAllOrientation = false
    }

    //가로모드 적용
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        appDelegate.shouldSupportAllOrientation = true
    }
}

class MyButtonCell: UICollectionViewCell {
    let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(button)

        // Button을 셀에 가운데 정렬
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

        // Button 액션 추가
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        // 초기 셀의 배경색을 초록색으로 설정
        contentView.backgroundColor = .green
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 버튼이 눌렸을 때의 동작
    @objc func buttonTapped() {
        // 버튼이 눌리면 셀의 배경색을 노란색으로 변경
        contentView.backgroundColor = .yellow

    }
}

extension PracticeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rows * columns // 행과 열에 따른 아이템 개수
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? MyButtonCell else {
            return UICollectionViewCell()
        }

        // 셀의 내용을 임의의 텍스트로 채움
        cell.button.setTitle("Item \(indexPath.item + 1)", for: .normal)

        return cell
    }
}


extension PracticeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 셀이 선택되었을 때 수행할 동작
        print("Cell selected at index: \(indexPath.item)")

        // 여기에서 버튼을 눌렀을 때의 동작을 수행할 수 있습니다.
    }
}
