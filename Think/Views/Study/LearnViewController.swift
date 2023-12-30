//
//  LearnViewController.swift
//  Think
//
//  Created by 김민섭 on 12/28/23.
//

import UIKit

class LearnViewController: UIViewController {

    lazy var button1: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Button 1", for: .normal)
        button.addTarget(self, action: #selector(button1Tapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var student: UIButton = {
        let student = UIButton(type: .system)
        student.setTitle("student", for: .normal)
        student.addTarget(self, action: #selector(studentTapped(_:)), for: .touchUpInside)
        student.translatesAutoresizingMaskIntoConstraints = false
        return student
    }()

    var newButtons: [UIButton] = []

    lazy var backButton: UIButton = {
        let backButton = UIButton(type: .system)
        backButton.setTitle("뒤로", for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.backgroundColor = .white
        backButton.setTitleColor(.black, for: .normal)
        backButton.layer.cornerRadius = 20.5
        backButton.layer.borderWidth = 2
        backButton.layer.borderColor = UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0).cgColor
        backButton.titleLabel?.font = UIFont(name: "Pretendard", size: 17)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)

        return backButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupButtons()
        setupBackButton()
    }

    func setupBackButton() {
        view.addSubview(backButton)

        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10), // 수정: 상단 여백 20
            backButton.widthAnchor.constraint(equalToConstant: 40), // 수정: 가로 크기 43
            backButton.heightAnchor.constraint(equalToConstant: 40) // 수정: 세로 크기 343
        ])
    }
    
    func setupButtons() {
        view.addSubview(button1)
        view.addSubview(student)

        NSLayoutConstraint.activate([
            button1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button1.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            button1.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40)
        ])
        
        NSLayoutConstraint.activate([
            student.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            student.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            student.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -80)
        ])
    }

    @objc func button1Tapped(_ sender: UIButton) {
        print("Button 1 tapped")
        fetchDataAndUpdateButtons()

    }

    @objc func studentTapped(_ sender: UIButton) {
        print("student tapped")
        fetchDataAndUpdateButtons()
    }
    
    func fetchDataAndUpdateButtons() {
        fetchDataFromServer { result in
            DispatchQueue.main.async {
                self.updateButtonsWithData(result)
            }
        }
    }

    func updateButtonsWithData(_ data: [String]) {
        removeButtons()

        for (index, name) in data.enumerated() {
            let newButton = UIButton(type: .system)
            newButton.translatesAutoresizingMaskIntoConstraints = false
            newButton.addTarget(self, action: #selector(newButtonTapped(_:)), for: .touchUpInside)
            newButton.setTitle(name, for: .normal)
            newButton.titleLabel?.numberOfLines = 0
            newButton.titleLabel?.lineBreakMode = .byWordWrapping
            newButton.backgroundColor = .gray
            newButton.setTitleColor(.black, for: .normal)

            newButtons.append(newButton)
            view.addSubview(newButton)

            NSLayoutConstraint.activate([
                newButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -80),
                newButton.heightAnchor.constraint(equalToConstant: 40),
                newButton.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: CGFloat(30 * index)),
                newButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        }
    }



    func removeButtons() {
        for button in newButtons {
            button.removeFromSuperview()
        }
        newButtons.removeAll()
    }

    @objc func newButtonTapped(_ sender: UIButton) {
        print("New Button tapped")
        // Handle the tap event for the newly added button if needed
    }
    
    func fetchDataFromServer(completion: @escaping ([String]) -> Void) {
        guard let url = URL(string: "http://13.125.210.242:8080/api/v1/test/students") else {
            completion(["Failed to fetch data"])
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching data: \(error)")
                completion(["Failed to fetch data"])
                return
            }

            if let data = data {
                do {
                    // JSON 데이터를 파싱하여 배열로 변환
                    let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] ?? []
                    
                    // 배열에서 랜덤으로 3개의 데이터 선택
                    let randomData = jsonArray.shuffled().prefix(3).compactMap { $0["name"] as? String }

                    completion(randomData)
                } catch {
                    print("Error parsing JSON: \(error)")
                    completion(["Failed to fetch data"])
                }
            } else {
                completion(["Failed to fetch data"])
            }
        }

        task.resume()
    }

    @objc func backButtonTapped() {
        let alertController = UIAlertController(title: "", message: "학습을 종료할까요?", preferredStyle: .alert)

        let yesAction = UIAlertAction(title: "예", style: .default) { [weak self] _ in
            self?.goToHomeViewController()
        }
        
        let noAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)

        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        

        present(alertController, animated: true, completion: nil)
    }

    func goToHomeViewController() {
        let changeViewController = HomeViewController()
        let navigationController = UINavigationController(rootViewController: changeViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }

    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewWillAppear(_ animated: Bool) {
        appDelegate.shouldSupportAllOrientation = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        appDelegate.shouldSupportAllOrientation = true
    }
}
