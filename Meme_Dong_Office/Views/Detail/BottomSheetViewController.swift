//
//  BottomSheetViewController.swift
//  tap
//
//  Created by 김민섭 on 12/26/23.
//

import UIKit

class BottomSheetViewController: UIViewController {
    
    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red.withAlphaComponent(1.0)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        dimmedView.addGestureRecognizer(dimmedTap)
        dimmedView.isUserInteractionEnabled = true
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Your Text Here"
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit", for: .normal)
        button.tintColor = .blue
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()

    var defaultHeight: CGFloat = 550

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showBottomSheet()
    }
    
    private func setupUI() {
        view.addSubview(dimmedView)
        view.addSubview(bottomSheetView)
        
        dimmedView.alpha = 0.0
        
        setupLayout()
        
        bottomSheetView.addSubview(label)
        bottomSheetView.addSubview(editButton)

        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor, constant: -20),
            label.bottomAnchor.constraint(equalTo: bottomSheetView.bottomAnchor, constant: -20)
        ])
        
        editButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            editButton.topAnchor.constraint(equalTo: label.topAnchor, constant: 10),
            editButton.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor, constant: -20)
        ])
    }
    
    private func showBottomSheet() {
        let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding: CGFloat = view.safeAreaInsets.bottom
        
        bottomSheetViewTopConstraint.constant = (safeAreaHeight + bottomPadding) - defaultHeight
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedView.alpha = 0.7
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func setupLayout() {
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        bottomSheetView.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstant: CGFloat = 800
        
        bottomSheetViewTopConstraint = bottomSheetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstant)
        
        NSLayoutConstraint.activate([
            bottomSheetView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomSheetView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomSheetViewTopConstraint,
        ])
    }
    
    private let bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        
        return view
    }()
    
    private var bottomSheetViewTopConstraint: NSLayoutConstraint!
    
    private func hideBottomSheetAndGoBack() {
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        
        bottomSheetViewTopConstraint.constant = safeAreaHeight + bottomPadding
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedView.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideBottomSheetAndGoBack()
    }
    
    private let editTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "여기에 텍스트를 입력하세요"
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        return textField
    }()
    
    @objc private func editButtonTapped() {
        editTextField.text = label.text

        bottomSheetView.addSubview(editTextField)

        editTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // 위치를 상단 왼쪽에 고정
            editTextField.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 20),
            editTextField.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 20),
            // 다른 제약은 유지
            editTextField.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor, constant: -20),
            editTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // 텍스트 필드를 표시하고 UI를 업데이트합니다
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
            self.label.alpha = 0.0
            self.editButton.isHidden = true
        }

        // 텍스트 필드 외부를 탭하면 키보드를 닫고 UI를 복원합니다
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        dimmedView.addGestureRecognizer(tapGestureRecognizer)
    }


    @objc private func dismissKeyboard() {
        // 키보드를 닫고 UI를 업데이트합니다
        editTextField.resignFirstResponder()

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.label.alpha = 1.0
            self.editButton.isHidden = false
        }

        // 텍스트 필드를 bottomSheetView에서 제거합니다
        editTextField.removeFromSuperview()
    }


    private func updateLabelText(_ newText: String?) {
        let trimmedText = newText?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        // 트리밍된 텍스트가 비어있지 않으면 레이블 텍스트를 업데이트하고, 그렇지 않으면 기본값을 사용합니다.
        label.text = trimmedText.isEmpty ? "기본 텍스트" : trimmedText
    }

}
