import UIKit

//class UserViewController: UIViewController {
//    var viewModel = UserViewModel()
//    
//    var nameLabel = UILabel()
//    var idLabel = UILabel()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//
//        // 레이블 설정 및 뷰에 추가
//        setupLabel(nameLabel)
//        setupLabel(idLabel)
//
//        // 레이블의 제약 조건 설정
//        setLabelConstraints()
//
//        // 데이터 가져오기
//        viewModel.fetchUserData {
//            DispatchQueue.main.async {
//                self.updateUI()
//            }
//        }
//    }
//
//    // 레이블 기본 설정 메서드
//    func setupLabel(_ label: UILabel) {
//        label.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(label)
//    }
//
//    // 사용자 인터페이스 업데이트
//    func updateUI() {
//        nameLabel.text = viewModel.userName
//        idLabel.text = viewModel.userId
//    }
//
//    // 레이블 제약 조건 설정
//    func setLabelConstraints() {
//        NSLayoutConstraint.activate([
//            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
//            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
//            idLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
//            idLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
//        ])
//    }
//}

//class UserViewController: UIViewController, UITableViewDataSource {
//    var viewModel = UserViewModel()
//    var tableView: UITableView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // 테이블 뷰 초기화 및 설정
//        tableView = UITableView(frame: .zero, style: .plain)
//        tableView.dataSource = self
//        view.addSubview(tableView)
//
//        // 셀 등록
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UserCell")
//
//        // 제약 조건 설정
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
//        ])
//
//        // 데이터 로딩
//        viewModel.fetchUsersData {
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.numberOfUsers
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
//        cell.textLabel?.text = viewModel.userName(at: indexPath.row)
//        return cell
//    }
//}
