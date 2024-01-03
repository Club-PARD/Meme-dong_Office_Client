//
//  LearnViewController.swift
//  study
//
//  Created by 이신원 on 1/2/24.
//

import UIKit

class LearnViewController: UIViewController, UINavigationControllerDelegate{
    
    // MARK: - 교탁
    let rectangleBox = UIView()
    
    // MARK: - quizView Properties
    let quizView: UIView = {
        let view = UIView()
        view.layer.shadowOffset = CGSize(width: -2, height:0)
        view.layer.shadowOpacity = 0.1
        view.layer.masksToBounds = false
        
        return view
    }()
    
    
    lazy var quizViewProgressLabel:UILabel = {
        let label = UILabel()
        label.text = "0/\(studentList.count)"
        label.font = UIFont.systemFont(ofSize: 10)
        label.backgroundColor = UIColor(red: 249/255, green: 246/255, blue: 181/255, alpha: 1)
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    var quizViewOnboardingLabel:UILabel = {
        let label = UILabel()
        label.text = "이 자리는 누구일까요?"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    
    var buttonA:UIButton!
    var buttonB:UIButton!
    var buttonC:UIButton!
    
    //MARK: - resultView Properties
    let resultView: UIView = {
        let view = UIView()
        view.layer.shadowOffset = CGSize(width: -2, height:0)
        view.layer.shadowOpacity = 0.1
        view.layer.masksToBounds = false
        
        return view
    }()
    
    var resultCountLabel:UILabel = {
        let label = UILabel()
        label.text = "명을 외웠어요!"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    var resultOnboardingLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "틀린 아이의 자리를\n확인하고 다시 외워보세요"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        return label
    }()
    var resultRetryButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        
        let symbolImage = UIImage(named: "system_retry")
        button.setImage(symbolImage, for: .normal)
        button.tintColor = UIColor.systemYellow
        button.addTarget(self, action: #selector(retryButtonAction), for: .touchUpInside)
        
        // 버튼의 다른 스타일 설정
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 2
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.systemYellow.cgColor
        
        return button
    }()
    var resultGoHomeButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        
        let symbolImage = UIImage(named: "system_home")
        button.setImage(symbolImage, for: .normal)
        button.tintColor = UIColor.systemYellow
        button.addTarget(self, action: #selector(goHomeButtonAction), for: .touchUpInside)
        
        // 버튼의 다른 스타일 설정
        button.layer.cornerRadius = 20
        
        return button
    }()
    var resultRetryLabel:UILabel = {
        let label = UILabel()
        label.text = "다시 학습"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    var resultGoHomeLabel:UILabel = {
        let label = UILabel()
        label.text = "홈 화면"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    
    // MARK: - collectionView properties
    var gridColumns: Int
    var gridRows: Int
    var spacing: Bool
    var boxes: [Bool]
    var collectionView: UICollectionView!
    var studentList = ["김지훈", "박서연", "이민준", "최예은", "정지우", "송수연", "윤현우", "한지아", "조성민", "임하은", "오준호", "고유나", "신태현", "류민서", "안지후", "백지윤", "남도윤", "황하윤", "전윤호", "문서현", "양지원", "강수빈", "유준서", "권예지", "우시우", "홍예린", "서승민", "구지연", "허하준", "도유진"]
    
    var wrongList:[Int] = []
    var correctList:[Int] = []
    var processingList:[Int] = []
    
    var selectedIndex:[Int] = []
    var correctAnswer:Int = 0
    
    
    // MARK: - init
    init(rows: Int, columns: Int, spacing: Bool) {
        print(rows)
        self.gridRows = rows
        self.gridColumns = columns
        self.spacing = spacing
        self.boxes = Array(repeating: false, count: rows * columns)
        super.init(nibName: nil, bundle: nil)
    }
    
    
    // MARK: - viewDidLoad
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        processingList = createNumberList(n: gridRows*gridColumns)
        self.navigationController?.delegate = self
        addCustomButtonToView()
        
        configureUI()
    }
    
    
    // MARK: - processingList 에 0~studnetList.count-1 로 숫자 리스트 만들어주기
    func createNumberList(n: Int) -> [Int] {
        let numberList = Array(0...n-1)
        return numberList
    }
    
    // MARK: - collectionView 랜덤 설정 초기화
    func initializeRandomUI(){
        processingList.shuffle()
        self.selectedIndex = Array(self.processingList.prefix(3))
        self.processingList = processingList.filter{$0 != selectedIndex[0]}
        
        correctAnswer = selectedIndex[0]
        selectedIndex.shuffle()
        selectedIndex.shuffle()
        
    
        DispatchQueue.main.async { [weak self] in
            if let strongSelf = self {
                strongSelf.updateLabelInCollectionView(atIndex: strongSelf.correctAnswer, withText: "", color: UIColor.systemYellow)
            }
        }


        setupButton(button: buttonA, systemName: "a.circle", color: UIColor.lightGray, index: selectedIndex[0])
        setupButton(button: buttonB, systemName: "b.circle", color: UIColor.lightGray, index: selectedIndex[1])
        setupButton(button: buttonC, systemName: "c.circle", color: UIColor.lightGray, index: selectedIndex[2])
        
        quizViewProgressLabel.text = "\(studentList.count - processingList.count)/\(studentList.count)"
    }
    
    // MARK: - 재실행 버튼 선택시 변수 및 화면 초기화
    @objc func retryButtonAction(){
        wrongList = []
        correctList = []
        processingList = createNumberList(n: gridRows*gridColumns)
        
        resultView.isHidden = true
        
        initializeRandomUI()
        
        for index in processingList {
            updateLabelInCollectionView(atIndex: index, withText: "?" , color: UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0))
                
        }
        
        quizView.isHidden = false
    }
    
    // MARK: - 홈으로 이동
    @objc func goHomeButtonAction(){
        
    }
    

    // MARK: - quizView 위에 버튼 3개 만들기
    func createCustomButton(name:String, num:Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(name, for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        if let symbolName = num == 1 ? "a.circle" : (num == 2 ? "b.circle" : "c.circle"),
           let image = UIImage(systemName: symbolName)?.withTintColor(.lightGray, renderingMode: .alwaysOriginal) {
            button.setImage(image, for: .normal)
        }
        
        
        // 이미지와 텍스트 간격 조절
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 20)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -20)


            // 버튼의 다른 스타일 설정
            button.layer.cornerRadius = 22
            button.layer.borderWidth = 2
            button.backgroundColor = .white
            button.layer.borderColor = UIColor.lightGray.cgColor
            //button.tintColor = UIColor.lightGray // 이미지와 텍스트 색상
        button.addTarget(self, action: #selector(selectionAction(sender:)), for: .touchUpInside)
        button.contentEdgeInsets =  UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
            return button
        
    }
    
    
    // MARK: - quizView 위에 올릴 버튼 3개 선언
    func addCustomButtonToView() {
        buttonA = createCustomButton(name:"", num:1)
        buttonA.translatesAutoresizingMaskIntoConstraints = false
        quizView.addSubview(buttonA)
    
        buttonB = createCustomButton(name:"", num:2)
        buttonB.translatesAutoresizingMaskIntoConstraints = false
        quizView.addSubview(buttonB)
        
        buttonC = createCustomButton(name:"", num:3)
        buttonC.translatesAutoresizingMaskIntoConstraints = false
        quizView.addSubview(buttonC)

        // Auto Layout 제약조건 설정
        NSLayoutConstraint.activate([
            buttonA.centerXAnchor.constraint(equalTo: quizView.centerXAnchor),
            buttonA.centerYAnchor.constraint(equalTo: quizView.centerYAnchor),
            
            buttonB.centerXAnchor.constraint(equalTo: quizView.centerXAnchor),
            buttonB.topAnchor.constraint(equalTo: buttonA.bottomAnchor, constant: 10),
            
            buttonC.centerXAnchor.constraint(equalTo: quizView.centerXAnchor),
            buttonC.topAnchor.constraint(equalTo: buttonB.bottomAnchor, constant: 10)
            // 필요하다면 추가 제약조건 설정
        ])
    }
    
    // MARK: - 버튼 UI 설정
    func setupButton(button:UIButton, systemName:String, color:UIColor, index:Int) -> UIButton{
        
        if let image = UIImage(systemName: systemName)?.withTintColor(color, renderingMode: .alwaysOriginal) {
            button.setImage(image, for: .normal)
        }
        button.layer.borderColor = color.cgColor
        
        if color == UIColor.lightGray{
            button.setTitle(studentList[index], for: .normal)
            button.setTitleColor(.black, for: .normal)
        }
        else{
            button.setTitleColor(color, for: .normal)
        }
        
        
        return button
    }
    
    // MARK: - quizView에서 버튼 선택 시
    //          정답과 오답 보여줌
    //          이제까지 푼 학생 수 보여줌
    //          1초 뒤에 다음 문제로 넘어감
    @objc func selectionAction(sender: UIButton){
        
        if String(sender.title(for: .normal) ?? "") == studentList[correctAnswer]{
            //정답
            correctList.append(correctAnswer)
            
            setupButton(button: sender, systemName: "checkmark.circle.fill", color: UIColor.systemGreen, index: 0)//index 의미 없음
            updateLabelInCollectionView(atIndex: correctAnswer,withText: studentList[correctAnswer] , color: UIColor.systemGreen)
        }
        else{
            //틀림
            wrongList.append(correctAnswer)
            
            if buttonA.title(for: .normal) == studentList[correctAnswer]{
                setupButton(button: buttonA, systemName: "checkmark.circle.fill", color: UIColor.systemGreen, index: 0)//index 의미 없음
                
            }
            else if buttonB.title(for: .normal) == studentList[correctAnswer]{
                setupButton(button: buttonB, systemName: "checkmark.circle.fill", color: UIColor.systemGreen, index: 0)//index 의미 없음
            }
            else if buttonC.title(for: .normal) == studentList[correctAnswer]{
                setupButton(button: buttonC, systemName: "checkmark.circle.fill", color: UIColor.systemGreen, index: 0)//index 의미 없음
            }
            
            setupButton(button: sender, systemName: "x.circle.fill", color: UIColor.systemRed, index: 0)//index 의미 없음
            
            updateLabelInCollectionView(atIndex: correctAnswer,withText: studentList[correctAnswer] , color: UIColor.systemRed)
        }
        
        
        
        // 1초 후에 수행할 작업
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
            
            updateLabelInCollectionView(atIndex: correctAnswer,withText: studentList[correctAnswer] , color: UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0))
            
            self.processingList.shuffle()
            
            if(self.processingList.count == 0 ){
                quizView.isHidden = true
                resultView.isHidden = false
                resultCountLabel.text = "\(correctList.count)명을 외웠어요!"
                
                for index in wrongList {
                    let indexPath = IndexPath(row: index, section: 0)
                    if let cell = collectionView.cellForItem(at: indexPath) as? LearnCustomCollectionViewCell {
                        cell.updateBackground(color: UIColor.systemRed)
                    }
                        
                }
            }
            else{
                //3개 뽑기
                if(self.processingList.count < 3){
                    selectedIndex = Array(processingList.prefix(1))
                    self.processingList = processingList.filter{$0 != selectedIndex[0]}
                    correctAnswer = selectedIndex[0]
                    
                    var dummyList = correctList.filter{ !wrongList.contains($0)}
                    dummyList.shuffle()
                    selectedIndex.append(contentsOf: correctList.prefix(1))
                    selectedIndex.append(contentsOf: Array(dummyList.prefix(2)))
                    selectedIndex.shuffle()
                    
                    print("visit")
                    
                }else{
                    self.selectedIndex = Array(self.processingList.prefix(3))
                    self.processingList = processingList.filter{$0 != selectedIndex[0]}
                    
                    correctAnswer = selectedIndex[0]
                    selectedIndex.shuffle()
                    print(selectedIndex)
                    print(correctAnswer)
                }
                
                setupButton(button: buttonA, systemName: "a.circle", color: UIColor.lightGray, index: selectedIndex[0])
                setupButton(button: buttonB, systemName: "b.circle", color: UIColor.lightGray, index: selectedIndex[1])
                setupButton(button: buttonC, systemName: "c.circle", color: UIColor.lightGray, index: selectedIndex[2])
                
                updateLabelInCollectionView(atIndex: correctAnswer, withText: "" , color: UIColor.systemYellow)
                quizViewProgressLabel.text = "\(studentList.count - processingList.count)/\(studentList.count)"
            }
        }
    }
    
    
    // MARK: - collectionView cell UI update
    func updateLabelInCollectionView(atIndex index: Int, withText text: String, color: UIColor) {
        let indexPath = IndexPath(row: index, section: 0) // 섹션이 하나라고 가정
        if let cell = collectionView.cellForItem(at: indexPath) as? LearnCustomCollectionViewCell {
            cell.updateLabel(name: text)
            cell.updateBackground(color: color)
        }
    }

    
    
    // MARK: - UI 전체 Configuration
    private func configureUI() {
        view.backgroundColor = .white
        setupNav()
        setupRectangleBox()
        setupCollectionView()
        
        setupConstraints()
        setupQuizView()
        
        initializeRandomUI()
        setupResultView()
        resultView.isHidden = true
    }
    
    
    // MARK: - collectionView 등록
    private func setupCollectionView() {
        let layout = CustomCollectionView(columns: gridColumns, spacing: spacing)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(LearnCustomCollectionViewCell.self, forCellWithReuseIdentifier: LearnCustomCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
    
    }
    
    
    // MARK: - collectionView 및 교탁 배치
    private func setupConstraints() {
        guard let layout = collectionView.collectionViewLayout as? CustomCollectionView else {
            return
        }

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // Use properties from CustomGridLayout for totalCellWidth and totalCellHeight
        let spacenum = CGFloat(layout.gridColumns) - 1
        let totalCellWidth = (layout.cellWidth * CGFloat(layout.gridColumns)) + (layout.baseSpacing * spacenum)
        let totalCellHeight = (layout.cellHeight * CGFloat(gridRows)) + (layout.baseHeight * CGFloat(gridRows - 1))
        
        NSLayoutConstraint.activate([
            rectangleBox.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            rectangleBox.centerXAnchor.constraint(equalTo: view.leadingAnchor, constant: (view.frame.width-200)/2 + 20),
            rectangleBox.widthAnchor.constraint(equalToConstant: 300),
            rectangleBox.heightAnchor.constraint(equalToConstant: 30),
            
            collectionView.widthAnchor.constraint(equalToConstant: totalCellWidth),
            collectionView.heightAnchor.constraint(equalToConstant: totalCellHeight),
            collectionView.centerXAnchor.constraint(equalTo: view.leadingAnchor, constant: (view.frame.width-200)/2 + 20),
            //collectionView.topAnchor.constraint(equalTo: view.topAnchor)
            collectionView.bottomAnchor.constraint(equalTo: rectangleBox.topAnchor, constant: -10)
        ])
        
    }
    
    
    private func setupRectangleBox() {
        rectangleBox.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        rectangleBox.layer.cornerRadius = 10
        rectangleBox.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rectangleBox)
    }
    
    // MARK: - quizView 배치

    private func setupQuizView(){
        
        view.addSubview(quizView)
        view.addSubview(quizViewProgressLabel)
        view.addSubview(quizViewOnboardingLabel)
        
        
        
        quizView.backgroundColor = UIColor(red: 255, green: 250/255, blue: 220/255, alpha: 1)
        quizView.translatesAutoresizingMaskIntoConstraints = false
        quizViewProgressLabel.translatesAutoresizingMaskIntoConstraints = false
        quizViewOnboardingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            quizView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            quizView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            quizView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            quizView.widthAnchor.constraint(equalToConstant: 200),
            
            quizViewProgressLabel.topAnchor.constraint(equalTo: quizView.topAnchor, constant: 50),
            quizViewProgressLabel.centerXAnchor.constraint(equalTo: quizView.centerXAnchor),
            quizViewProgressLabel.widthAnchor.constraint(equalToConstant: 50),
            quizViewProgressLabel.heightAnchor.constraint(equalToConstant: 30),
            
            
            quizViewOnboardingLabel.topAnchor.constraint(equalTo: quizViewProgressLabel.bottomAnchor, constant: 20),
            quizViewOnboardingLabel.centerXAnchor.constraint(equalTo: quizView.centerXAnchor),
            
            
        ])
    }
    
    
    // MARK: - resultView 배치
    
    private func setupResultView(){
        view.addSubview(resultView)
        resultView.backgroundColor = UIColor(red: 255, green: 250/255, blue: 220/255, alpha: 1)
        
        resultView.addSubview(resultCountLabel)
        resultView.addSubview(resultOnboardingLabel)
        resultView.addSubview(resultRetryButton)
        resultView.addSubview(resultRetryLabel)
        resultView.addSubview(resultGoHomeButton)
        resultView.addSubview(resultGoHomeLabel)
        
        resultView.translatesAutoresizingMaskIntoConstraints = false
        resultCountLabel.translatesAutoresizingMaskIntoConstraints = false
        resultOnboardingLabel.translatesAutoresizingMaskIntoConstraints = false
        resultRetryButton.translatesAutoresizingMaskIntoConstraints = false
        resultRetryLabel.translatesAutoresizingMaskIntoConstraints = false
        resultGoHomeButton.translatesAutoresizingMaskIntoConstraints = false
        resultGoHomeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            resultView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            resultView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            resultView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            resultView.widthAnchor.constraint(equalToConstant: 200),
            
            resultCountLabel.topAnchor.constraint(equalTo: resultView.topAnchor, constant: 50),
            resultCountLabel.centerXAnchor.constraint(equalTo: resultView.centerXAnchor),
            
            resultOnboardingLabel.topAnchor.constraint(equalTo: resultCountLabel.bottomAnchor, constant: 20),
            resultOnboardingLabel.centerXAnchor.constraint(equalTo: resultView.centerXAnchor),
            
            resultRetryLabel.centerXAnchor.constraint(equalTo: resultView.leadingAnchor, constant: 50),
            resultRetryLabel.bottomAnchor.constraint(equalTo: resultView.bottomAnchor,constant: -40),
            
            resultRetryButton.centerXAnchor.constraint(equalTo: resultView.leadingAnchor, constant: 50),
            resultRetryButton.bottomAnchor.constraint(equalTo: resultRetryLabel.topAnchor,constant: -5),
            resultRetryButton.widthAnchor.constraint(equalToConstant: 90),
            resultRetryButton.heightAnchor.constraint(equalToConstant: 40),
            
            resultGoHomeLabel.centerXAnchor.constraint(equalTo: resultView.leadingAnchor, constant: 150),
            resultGoHomeLabel.bottomAnchor.constraint(equalTo: resultView.bottomAnchor,constant: -40),
            
            resultGoHomeButton.centerXAnchor.constraint(equalTo: resultView.leadingAnchor, constant: 150),
            resultGoHomeButton.bottomAnchor.constraint(equalTo: resultGoHomeLabel.topAnchor,constant: -5),
            resultGoHomeButton.widthAnchor.constraint(equalToConstant: 90),
            resultGoHomeButton.heightAnchor.constraint(equalToConstant: 40),
            
            
        ])
    }
    
    
    // MARK: - navigation 세팅
    
    func setupNav(){
        navigationItem.title = "학습하기"
        
        //ios 15부터 적용
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.white // 배경색을 흰색으로 설정
        
        appearance.shadowColor = nil

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
    }
    
    
    // MARK: - 뒤로가기 버튼 관련
//    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//            if viewController is LearnViewController {
//                let alertController = UIAlertController(title: "경고", message: "학습을 종료할까요?", preferredStyle: .alert)
//
//                let yesAction = UIAlertAction(title: "예", style: .default) { [weak self] _ in
//                    // 사용자가 '예'를 선택했을 때의 동작을 여기에 작성합니다.
//                    // 예를 들어, navigationController를 통해 이전 뷰로 이동할 수 있습니다.
//                    self?.navigationController?.popViewController(animated: true)
//                }
//
//                let noAction = UIAlertAction(title: "아니오", style: .cancel) { [weak self] _ in
//                    // '아니오'를 선택했을 때는 아무것도 하지 않습니다.
//                    // 이 부분에서는 viewController가 이미 뒤로 갈 준비가 되어 있으므로,
//                    // 실제로 이전 화면으로 돌아가지 않도록 현재 뷰 컨트롤러를 다시 푸시합니다.
//                    navigationController.pushViewController(self!, animated: false)
//                }
//
//                alertController.addAction(noAction)
//                alertController.addAction(yesAction)
//
//                // 팝업 창을 띄웁니다.
//                self.present(alertController, animated: true, completion: nil)
//            }
//        }
    
    
    func goToHomeViewController() {
        let changeViewController = ViewController()
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

extension LearnViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gridRows * gridColumns
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LearnCustomCollectionViewCell.identifier, for: indexPath) as? LearnCustomCollectionViewCell else {
            fatalError("Unable to dequeue LearnCustomCollectionViewCell")
        }
        cell.configure(with: "?")//studentList[indexPath.row]
        return cell
    }
    
    
}
