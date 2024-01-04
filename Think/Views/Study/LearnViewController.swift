//
//  LearnViewController.swift
//  study
//
//  Created by 이신원 on 1/2/24.
//

import UIKit

class LearnViewController: UIViewController, UINavigationControllerDelegate{
    
    let classroomViewModel = ClassroomViewModel.shared
    // MARK: - 교탁
    let rectangleBox = UIView()
    
    // MARK: - Custom pop up initializers
    let customAlertView = UIView()
    let overlayView = UIView()
    
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
        label.text = "0/\(classroomViewModel.classroom.studentsCount!)"
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
//    var studentList = ["김지훈", "박서연", "이민준", "최예은", "정지우", "송수연", "윤현우", "한지아", "조성민", "임하은", "오준호", "고유나", "신태현", "류민서", "안지후", "백지윤", "남도윤", "황하윤", "전윤호", "문서현", "양지원", "강수빈", "유준서", "권예지", "우시우", "홍예린", "서승민", "구지연", "허하준", "도유진"]
    
    var wrongList:[Int] = []
    var correctList:[Int] = []
    var processingList:[Int] = []
    
    var selectedIndex:[Int] = []
    var correctAnswer:Int = 0
    
    
    // MARK: - init
    init() {
        self.gridRows = classroomViewModel.classroom.listRow!
        self.gridColumns = classroomViewModel.classroom.listCol!
        self.spacing = classroomViewModel.classroom.seatSpacing!
        self.boxes = Array(repeating: false, count: self.gridRows * self.gridColumns)
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
        
        quizViewProgressLabel.text = "\(classroomViewModel.classroom.studentsCount! - processingList.count)/\(classroomViewModel.classroom.studentsCount!)"
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
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -10)


            // 버튼의 다른 스타일 설정
            button.layer.cornerRadius = 22
            button.layer.borderWidth = 2
            button.backgroundColor = .white
            button.layer.borderColor = UIColor.lightGray.cgColor
            //button.tintColor = UIColor.lightGray // 이미지와 텍스트 색상
        button.addTarget(self, action: #selector(selectionAction(sender:)), for: .touchUpInside)
        button.contentEdgeInsets =  UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 30)
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
            button.setTitle(classroomViewModel.classroom.studentsList![index].name!, for: .normal)
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
        
        if String(sender.title(for: .normal) ?? "") == classroomViewModel.classroom.studentsList![correctAnswer].name! {
            //정답
            correctList.append(correctAnswer)
            
            setupButton(button: sender, systemName: "checkmark.circle.fill", color: UIColor.systemGreen, index: 0)//index 의미 없음
            updateLabelInCollectionView(atIndex: correctAnswer,withText: classroomViewModel.classroom.studentsList![correctAnswer].name! , color: UIColor.systemGreen)
        }
        else{
            //틀림
            wrongList.append(correctAnswer)
            
            if buttonA.title(for: .normal) == classroomViewModel.classroom.studentsList![correctAnswer].name!{
                setupButton(button: buttonA, systemName: "checkmark.circle.fill", color: UIColor.systemGreen, index: 0)//index 의미 없음
                
            }
            else if buttonB.title(for: .normal) == classroomViewModel.classroom.studentsList![correctAnswer].name!{
                setupButton(button: buttonB, systemName: "checkmark.circle.fill", color: UIColor.systemGreen, index: 0)//index 의미 없음
            }
            else if buttonC.title(for: .normal) == classroomViewModel.classroom.studentsList![correctAnswer].name!{
                setupButton(button: buttonC, systemName: "checkmark.circle.fill", color: UIColor.systemGreen, index: 0)//index 의미 없음
            }
            
            setupButton(button: sender, systemName: "x.circle.fill", color: UIColor.systemRed, index: 0)//index 의미 없음
            
            updateLabelInCollectionView(atIndex: correctAnswer,withText: classroomViewModel.classroom.studentsList![correctAnswer].name! , color: UIColor.systemRed)
        }
        
        
        
        // 1초 후에 수행할 작업
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
            
            updateLabelInCollectionView(atIndex: correctAnswer,withText: classroomViewModel.classroom.studentsList![correctAnswer].name! , color: UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0))
            
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
                quizViewProgressLabel.text = "\(classroomViewModel.classroom.studentsCount! - processingList.count)/\(classroomViewModel.classroom.studentsCount!)"
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
        customizeBackButton()

    }
    
    
    // MARK: - collectionView 등록
    private func setupCollectionView() {
        let layout = CustomCollectionView(columns: gridColumns, spacing: spacing,cellHeight:55, cellWidth:60)
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
            rectangleBox.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -75),
            rectangleBox.widthAnchor.constraint(equalToConstant: 300),
            rectangleBox.heightAnchor.constraint(equalToConstant: 30),
            
//            collectionView.widthAnchor.constraint(equalToConstant: totalCellWidth),
//            collectionView.heightAnchor.constraint(equalToConstant: totalCellHeight),
//            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -75),
//            //collectionView.topAnchor.constraint(equalTo: view.topAnchor)
//            collectionView.bottomAnchor.constraint(equalTo: rectangleBox.topAnchor, constant: -10)
//            
            collectionView.widthAnchor.constraint(equalToConstant: totalCellWidth),
            collectionView.heightAnchor.constraint(equalToConstant: totalCellHeight),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -75),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -10),
            
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
        
        //appearance.shadowColor = nil

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
    }
    
    // MARK: - 뒤로가기 버튼 관련
    private func customizeBackButton() {
        self.navigationItem.hidesBackButton = true
        
        let backImage = UIImage(systemName: "chevron.backward")?.withRenderingMode(.alwaysOriginal)
        let customBackButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(showCustomAlert))
        
        customBackButton.tintColor = .black
        
        self.navigationItem.leftBarButtonItem = customBackButton
    }


    // MARK: - Custom PopUp
    private func setupCustomAlert() {
           overlayView.frame = self.view.bounds
           overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
           overlayView.alpha = 0

           customAlertView.backgroundColor = .white
           customAlertView.layer.cornerRadius = 15
           customAlertView.translatesAutoresizingMaskIntoConstraints = false
           customAlertView.alpha = 0

           let titleLabel = UILabel()
           titleLabel.text = "학습을 종료하시겠어요?"
           titleLabel.translatesAutoresizingMaskIntoConstraints = false
           
            let messageLabel = UILabel()
            messageLabel.text = "진행된 학습 데이터가 사라집니다"
            messageLabel.textColor = UIColor.lightGray
            messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            messageLabel.numberOfLines = 0

            // Create and configure the icon at the top
            let iconImageView = UIImageView()
            iconImageView.image = UIImage(systemName: "exclamationmark.circle.fill")
            iconImageView.tintColor = .lightGray
            iconImageView.contentMode = .scaleAspectFit
            iconImageView.translatesAutoresizingMaskIntoConstraints = false
           
            let cancelButton = UIButton(type: .system)
            cancelButton.setTitle("취소", for: .normal)
            cancelButton.tintColor = UIColor.black
            cancelButton.backgroundColor = UIColor.lightGray
            cancelButton.layer.cornerRadius = 15
            cancelButton.addTarget(self, action: #selector(dismissCustomAlert), for: .touchUpInside)
            cancelButton.translatesAutoresizingMaskIntoConstraints = false

           
           let confirmButton = UIButton(type: .system)
           confirmButton.setTitle("종료", for: .normal)
           confirmButton.backgroundColor = UIColor.systemYellow
           confirmButton.tintColor = UIColor.black
           confirmButton.layer.cornerRadius = 15
           confirmButton.addTarget(self, action: #selector(confirmAndDismissCustomAlert), for: .touchUpInside)
           confirmButton.translatesAutoresizingMaskIntoConstraints = false

           customAlertView.addSubview(titleLabel)
           customAlertView.addSubview(messageLabel)
           customAlertView.addSubview(cancelButton)
           customAlertView.addSubview(confirmButton)
           
           view.addSubview(overlayView)
           view.addSubview(customAlertView)
            customAlertView.addSubview(iconImageView)

           NSLayoutConstraint.activate([
               customAlertView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
               customAlertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               customAlertView.widthAnchor.constraint(equalToConstant: 387),
               customAlertView.heightAnchor.constraint(equalToConstant: 226),
               
               iconImageView.centerXAnchor.constraint(equalTo: customAlertView.centerXAnchor),
               iconImageView.topAnchor.constraint(equalTo: customAlertView.topAnchor, constant: 14),
               iconImageView.widthAnchor.constraint(equalToConstant: 34),
               iconImageView.heightAnchor.constraint(equalToConstant: 34),

               
               titleLabel.topAnchor.constraint(equalTo: customAlertView.topAnchor, constant: 77),
               titleLabel.centerXAnchor.constraint(equalTo: customAlertView.centerXAnchor),
               
               messageLabel.centerXAnchor.constraint(equalTo: customAlertView.centerXAnchor),
               messageLabel.topAnchor.constraint(equalTo: customAlertView.topAnchor, constant: 109),

               cancelButton.leadingAnchor.constraint(equalTo: customAlertView.leadingAnchor, constant: 67),
               cancelButton.bottomAnchor.constraint(equalTo: customAlertView.bottomAnchor, constant: -28),
               cancelButton.widthAnchor.constraint(equalToConstant: 115),
               cancelButton.heightAnchor.constraint(equalToConstant: 40),
               
               confirmButton.trailingAnchor.constraint(equalTo: customAlertView.trailingAnchor, constant: -69),
               confirmButton.bottomAnchor.constraint(equalTo: customAlertView.bottomAnchor, constant: -28),
               confirmButton.widthAnchor.constraint(equalToConstant: 115),
               confirmButton.heightAnchor.constraint(equalToConstant: 40)
           ])
       }

       @objc private func dismissCustomAlert() {
           UIView.animate(withDuration: 0.3) {
               self.customAlertView.alpha = 0
               self.overlayView.alpha = 0
           } completion: { _ in
               self.customAlertView.removeFromSuperview()
               self.overlayView.removeFromSuperview()
           }
       }

       @objc private func confirmAndDismissCustomAlert() {
           // Handle the confirmation action here
           // For example, pop the view controller or reset the quiz
           navigationController?.popViewController(animated: true)
       }

        @objc func showCustomAlert() {
           setupCustomAlert()

           UIView.animate(withDuration: 0.3) {
               self.customAlertView.alpha = 1
               self.overlayView.alpha = 1
           }
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


