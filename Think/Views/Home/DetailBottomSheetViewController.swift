import UIKit

class DetailBottomSheetViewController:UIViewController {
    let classroomViewModel = ClassroomViewModel.shared
     
     var bottomSheetPanMinTopConstant: CGFloat = 30.0
     private lazy var bottomSheetPanStartingTopConstant: CGFloat = bottomSheetPanMinTopConstant

    private let bottomSheetWidth: CGFloat = 200
    
    private var bottomSheetViewLeadingConstraint: NSLayoutConstraint!
     
     private let dimmedView: UIView = {
         let view = UIView()
         view.backgroundColor = UIColor.clear
         return view
     }()
     
     private let bottomSheetView:UIView = {
         let view = UIView()
         view.backgroundColor = UIColor(red: 156/255, green: 197/255, blue: 231/255, alpha: 1.0)
         
         view.layer.cornerRadius = 10
         view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
         view.clipsToBounds = true
         return view
     }()


    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "xmark") // "closeIcon"은 에셋 카탈로그에 있는 이미지의 이름입니다
        button.setImage(image, for: .normal)
        button.tintColor = .black // 필요한 경우 이미지의 색상을 변경
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
     
     var studentNameLabel: UILabel = {
          let label = UILabel()
          label.text = "김김김"
          label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
          return label
     }()
     
     private let roundBackgroundView: UIView = {
         let view = UIView()
         // Convert hex color #F0F0F0 to RGB and then to UIColor
          view.backgroundColor = UIColor.white
         // Set the desired corner radius.
         view.layer.cornerRadius = 10
         view.clipsToBounds = true
         return view
     }()

     
     private let birthdateLabel: UILabel = {
          let label = UILabel()
          label.text = "생년월일 "
          label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
          return label
     }()

     private let allergiesLabel: UILabel = {
          let label = UILabel()
          label.text = "알레르기 "
          label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
          return label
     }()

     private let otherInfoLabel: UILabel = {
          let label = UILabel()
          label.text = "기타 "
          label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
          return label
     }()
    
     
     private let birthTextField: UITextField = {
         
         let datePicker = UIDatePicker()
         datePicker.datePickerMode = .date

         // iOS 14 이상에서는 datePicker의 스타일을 compact, inline 또는 wheels 중 하나로 설정할 수 있습니다.
         if #available(iOS 13.4, *) {
             datePicker.preferredDatePickerStyle = .wheels
         }
         
         
         let textField = UITextField()
         textField.inputView = datePicker
         textField.borderStyle = .none
         textField.clearButtonMode = .whileEditing
         textField.isEnabled = false
         textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
         // UIDatePicker에 대한 액션 추가
         datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)

         return textField
     }()

     private let alleTextField: UITextField = {
         let textField = UITextField()
         textField.borderStyle = .none
         textField.clearButtonMode = .whileEditing
         textField.isEnabled = false
         textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
         return textField
     }()

     private let otherInfoTextField: UITextField = {
         let textField = UITextField()
         textField.borderStyle = .none
         textField.clearButtonMode = .whileEditing
         textField.isEnabled = false
         textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
         return textField
     }()
     
     let birthView = UIView()
     let alleView = UIView()
     let otherInfoView = UIView()

    
    var imageButton: UIButton = {
        let button = UIButton()
        if let image = UIImage(named: "Image") {
            button.setImage(image, for: .normal)
        }
        button.imageView?.contentMode = .scaleAspectFit
        button.clipsToBounds = true
        button.isEnabled = false
        button.addTarget(self, action: #selector(imageButtonTapped), for: .touchUpInside)

        return button
    }()
    
    let editCompleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("완료", for: .normal)
        button.tintColor = .black
        button.isHidden = true
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(red: 0/255, green: 148/255, blue: 255/255, alpha: 1).cgColor
        button.backgroundColor = .white
        button.layer.shadowRadius = 2
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        button.addTarget(self, action: #selector(editCompleteButtonAction), for: .touchUpInside)
        return button
    }()

     private let editButton: UIButton = {
         let button = UIButton(type: .system)
         let image = UIImage(named: "pencil")
         button.setBackgroundImage(image, for: .normal)
         button.tintColor = .black
         button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
         return button
     }()
    
    var topAnchor = NSLayoutConstraint()
    var bottomAnchor = NSLayoutConstraint()
    var centerYAnchor = NSLayoutConstraint()
    var centerXAnchor = NSLayoutConstraint()
    var widthAnchor = NSLayoutConstraint()
    var heightAnchor = NSLayoutConstraint()
    var trailingAnchor = NSLayoutConstraint()
    var leadingAnchor = NSLayoutConstraint()
    
    
    
     private var bottomSheetViewTopConstraint: NSLayoutConstraint!
    
    var index:Int
    
    @objc func dateChanged(_ datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        birthTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    //MARK: layout
    var initialImageButtonConstraints: [NSLayoutConstraint] = []
    var roundBackgroundViewConstraints: [NSLayoutConstraint] = []
    var editCompleteButtonConstraints: [NSLayoutConstraint] = []
    
    // MARK: - Initializer
    init(index: Int) {
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        showBottomSheet()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        setupUI()
        registerKeyboardNotifications()
        hideKeyboardWhenTappedAround()
        
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
            dimmedView.addGestureRecognizer(dimmedTap)
            dimmedView.isUserInteractionEnabled = true
        
        
        
    }
    
     
     private func setupUI(){
         
         studentNameLabel.text = classroomViewModel.classroom.studentsList?[index].name
         alleTextField.text = classroomViewModel.classroom.studentsList?[index].allergy
         
         let dateTimeString = classroomViewModel.classroom.studentsList?[index].birthday
         let dateString = dateTimeString?.split(separator: "T").first.map(String.init) ?? ""
         print(dateString)
         
         birthTextField.text = dateString
         
         otherInfoTextField.text = classroomViewModel.classroom.studentsList?[index].etc
         view.addSubview(dimmedView)
         view.addSubview(bottomSheetView)
          view.addSubview(closeButton)
                  
         setupLayout()
     }
    
     
     private func setupLayout(){
          
          bottomSheetView.translatesAutoresizingMaskIntoConstraints = false
        
          bottomSheetViewLeadingConstraint = bottomSheetView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        NSLayoutConstraint.activate([
            bottomSheetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bottomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSheetViewLeadingConstraint
        ])
          
          
          bottomSheetView.addSubview(roundBackgroundView)
          bottomSheetView.addSubview(birthdateLabel)
          bottomSheetView.addSubview(allergiesLabel)
          bottomSheetView.addSubview(otherInfoLabel)
          bottomSheetView.addSubview(imageButton)
          bottomSheetView.addSubview(editButton)
          
          bottomSheetView.addSubview(birthView)
          bottomSheetView.addSubview(alleView)
          bottomSheetView.addSubview(otherInfoView)
         
          bottomSheetView.addSubview(alleTextField)
          bottomSheetView.addSubview(birthTextField)
          bottomSheetView.addSubview(otherInfoTextField)
          
          bottomSheetView.addSubview(studentNameLabel)
         bottomSheetView.addSubview(editCompleteButton)
          

          birthdateLabel.translatesAutoresizingMaskIntoConstraints = false
          allergiesLabel.translatesAutoresizingMaskIntoConstraints = false
          otherInfoLabel.translatesAutoresizingMaskIntoConstraints = false
          dimmedView.translatesAutoresizingMaskIntoConstraints = false
          roundBackgroundView.translatesAutoresizingMaskIntoConstraints = false
          closeButton.translatesAutoresizingMaskIntoConstraints = false
          
          birthView.translatesAutoresizingMaskIntoConstraints = false
          alleView.translatesAutoresizingMaskIntoConstraints = false
          otherInfoView.translatesAutoresizingMaskIntoConstraints = false
          
         birthTextField.translatesAutoresizingMaskIntoConstraints = false
         alleTextField.translatesAutoresizingMaskIntoConstraints = false
         otherInfoTextField.translatesAutoresizingMaskIntoConstraints = false
         
         editCompleteButton.translatesAutoresizingMaskIntoConstraints = false
          
//          configureLabelBackground(for: updatedBirthdateLabel)
//          configureLabelBackground(for: updatedAllergiesLabel)
//          configureLabelBackground(for: updatedOtherInfoLabel)
//
          birthView.backgroundColor = UIColor(red: 219/255, green: 242/255, blue: 255/255, alpha: 1)
          birthView.layer.cornerRadius = 5
          
          alleView.backgroundColor = UIColor(red: 219/255, green: 242/255, blue: 255/255, alpha: 1)
          alleView.layer.cornerRadius = 5
          
          otherInfoView.backgroundColor = UIColor(red: 219/255, green: 242/255, blue: 255/255, alpha: 1)
          otherInfoView.layer.cornerRadius = 5
          
          
          NSLayoutConstraint.activate([
              closeButton.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 20),
              closeButton.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor, constant: -30),
              closeButton.widthAnchor.constraint(equalToConstant: 17),
              closeButton.heightAnchor.constraint(equalToConstant: 17)
          ])
         
         let centerXAnchorConstraint = roundBackgroundView.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor)
         let bottomAnchorConstraint =  roundBackgroundView.bottomAnchor.constraint(equalTo: bottomSheetView.bottomAnchor, constant: -20)
         let widthAnchorConstraint = roundBackgroundView.widthAnchor.constraint(equalToConstant: 200)
         let heightAnchorConstraint = roundBackgroundView.heightAnchor.constraint(equalToConstant: 160)
         roundBackgroundViewConstraints = [centerXAnchorConstraint, bottomAnchorConstraint, widthAnchorConstraint, heightAnchorConstraint]
        NSLayoutConstraint.activate(roundBackgroundViewConstraints)
         
        
//          NSLayoutConstraint.activate([
//                  // Constraints for roundBackgroundView to define its position and size
//                  roundBackgroundView.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor),
//                  roundBackgroundView.bottomAnchor.constraint(equalTo: bottomSheetView.bottomAnchor, constant: -20), // Adjust this as needed
//                  roundBackgroundView.widthAnchor.constraint(equalToConstant: 200), // Adjust this as needed
//                  roundBackgroundView.heightAnchor.constraint(equalToConstant: 160), // Adjust this based on the content
//              ])

              // Constraints for birthdateLabel
              NSLayoutConstraint.activate([
                  birthdateLabel.topAnchor.constraint(equalTo: roundBackgroundView.topAnchor, constant: 15),
                  birthdateLabel.leadingAnchor.constraint(equalTo: roundBackgroundView.leadingAnchor, constant: 15)
              ])

              // Constraints for allergiesLabel
              NSLayoutConstraint.activate([
                  allergiesLabel.topAnchor.constraint(equalTo: birthdateLabel.bottomAnchor, constant: 10),
                  allergiesLabel.leadingAnchor.constraint(equalTo: birthdateLabel.leadingAnchor)
              ])

              // Constraints for otherInfoLabel
              NSLayoutConstraint.activate([
                  
                  otherInfoLabel.topAnchor.constraint(equalTo: allergiesLabel.bottomAnchor, constant: 10),
                  otherInfoLabel.leadingAnchor.constraint(equalTo: birthdateLabel.leadingAnchor)
                  
              ])
          
          NSLayoutConstraint.activate([
               birthView.leadingAnchor.constraint(equalTo: birthdateLabel.trailingAnchor, constant: 10),
               birthView.topAnchor.constraint(equalTo: birthdateLabel.topAnchor,constant: -2),
//               birthView.trailingAnchor.constraint(equalTo: roundBackgroundView.trailingAnchor, constant: -10),
               birthView.heightAnchor.constraint(equalToConstant: 20),
               birthView.trailingAnchor.constraint(equalTo: roundBackgroundView.trailingAnchor, constant: -10),
               
               alleView.leadingAnchor.constraint(equalTo: birthdateLabel.trailingAnchor, constant: 10),
               alleView.topAnchor.constraint(equalTo: allergiesLabel.topAnchor,constant: -2),
               alleView.trailingAnchor.constraint(equalTo: roundBackgroundView.trailingAnchor, constant: -10),
               alleView.heightAnchor.constraint(equalToConstant: 20),
               
               otherInfoView.leadingAnchor.constraint(equalTo: birthdateLabel.trailingAnchor, constant: 10),
               otherInfoView.topAnchor.constraint(equalTo: otherInfoLabel.topAnchor,constant: -2),
               otherInfoView.bottomAnchor.constraint(equalTo: roundBackgroundView.bottomAnchor, constant: -10),
               otherInfoView.trailingAnchor.constraint(equalTo: roundBackgroundView.trailingAnchor, constant: -10),
               
               birthTextField.leadingAnchor.constraint(equalTo: birthView.leadingAnchor, constant: 10),
               birthTextField.topAnchor.constraint(equalTo: birthdateLabel.topAnchor),
               birthTextField.widthAnchor.constraint(equalToConstant: 155),
                  
               alleTextField.leadingAnchor.constraint(equalTo: alleView.leadingAnchor, constant: 10),
               alleTextField.topAnchor.constraint(equalTo: allergiesLabel.topAnchor),
               alleTextField.widthAnchor.constraint(equalToConstant: 155),
                  
               otherInfoTextField.leadingAnchor.constraint(equalTo: alleView.leadingAnchor, constant: 10),
               otherInfoTextField.topAnchor.constraint(equalTo: otherInfoLabel.topAnchor),
//               otherInfoTextField.trailingAnchor.constraint(equalTo: otherInfoView.trailingAnchor, constant: -10),
               otherInfoTextField.widthAnchor.constraint(equalToConstant: 155),
          ])

          
         NSLayoutConstraint.activate([
             dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
             dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
         ])
        
         imageButton.translatesAutoresizingMaskIntoConstraints = false
          
         let topAnchorConstraint = imageButton.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 41)
         let leadingAnchorConstraint = imageButton.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: -40)
         let heightConstraint = imageButton.heightAnchor.constraint(equalToConstant: 130)

        initialImageButtonConstraints = [topAnchorConstraint, leadingAnchorConstraint, heightConstraint]
        NSLayoutConstraint.activate(initialImageButtonConstraints)
         
//          NSLayoutConstraint.activate([
//            imageButton.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 41),
//            imageButton.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: -40),
//            imageButton.heightAnchor.constraint(equalToConstant: 130)
//          ])
          
          studentNameLabel.translatesAutoresizingMaskIntoConstraints = false
          
          NSLayoutConstraint.activate([
               studentNameLabel.topAnchor.constraint(equalTo: imageButton.bottomAnchor, constant: 10),
               
               studentNameLabel.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor),
          ])
          
          editButton.translatesAutoresizingMaskIntoConstraints = false
                  
                  // 연필 버튼 레이아웃 설정
          // Constraints for editButton
              NSLayoutConstraint.activate([
               editButton.topAnchor.constraint(equalTo: imageButton.bottomAnchor, constant: 10),
               editButton.leadingAnchor.constraint(equalTo: studentNameLabel.trailingAnchor, constant: 10),
                  editButton.widthAnchor.constraint(equalToConstant: 15),
                  editButton.heightAnchor.constraint(equalToConstant: 15)
              ])
          otherInfoView.bringSubviewToFront(editButton)
         
         
         widthAnchor = editCompleteButton.widthAnchor.constraint(equalToConstant: 110)
         heightAnchor =  editCompleteButton.heightAnchor.constraint(equalToConstant: 40)
         bottomAnchor = editCompleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
         trailingAnchor = editCompleteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -30)
         editCompleteButtonConstraints = [widthAnchor, heightAnchor, bottomAnchor, trailingAnchor]
        NSLayoutConstraint.activate(editCompleteButtonConstraints)
         
    }
    
    private func showBottomSheet(){
        // In landscape mode, the bottom sheet slides in from the right, so we change the leading constraint
        bottomSheetViewLeadingConstraint.constant = -bottomSheetWidth
        
        UIView.animate(withDuration: 0.25, delay:0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    
    
     @objc private func closeButtonTapped() {
          hideBottomSheetAndGoBack()
     }

    @objc private func imageButtonTapped() {
        
        
    }

     private func hideBottomSheetAndGoBack() {
         bottomSheetViewLeadingConstraint.constant = bottomSheetWidth

         UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
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
    
    @objc private func editCompleteButtonAction(){
        //modifyStudentDetail(index:Int, completion: @escaping (Bool) -> Void)
        
        classroomViewModel.classroom.studentsList?[index].birthday = birthTextField.text
        classroomViewModel.classroom.studentsList?[index].allergy = alleTextField.text
        classroomViewModel.classroom.studentsList?[index].etc = otherInfoTextField.text
        
        ClassroomViewModel.shared.modifyStudentDetail(index: index) { success in
            DispatchQueue.main.async {
                if success {
                    print("변경 success!!")
                    
                    self.hideBottomSheetAndGoBack()
                    
                    
                    } else {
                    print("error!!")
                }
            }
        }
        
        
    }

     @objc private func editButtonTapped() {
         self.expandBottomSheetToFullScreen()
         
         editButton.isHidden = true
         birthTextField.isEnabled = true
         alleTextField.isEnabled = true
         otherInfoTextField.isEnabled = true
         editCompleteButton.isHidden = false
         
         
         layoutMiddle()
         
         
         NSLayoutConstraint.activate([
            studentNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            studentNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
//            imageButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            imageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -150),
            
//            roundBackgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
//            roundBackgroundView.leadingAnchor.constraint(equalTo: imageButton.trailingAnchor, constant: 20),
//            roundBackgroundView.widthAnchor.constraint(equalToConstant: 250),
//            roundBackgroundView.heightAnchor.constraint(equalToConstant: 160),
            
         ])
         
         
     }
    
    
    private func expandBottomSheetToFullScreen() {
        // 화면 전체 너비 설정
        let screenWidth = UIScreen.main.bounds.width
        bottomSheetViewLeadingConstraint.constant = -screenWidth
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    
    private func registerKeyboardNotifications() {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        }

        @objc private func keyboardWillShow(notification: NSNotification) {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                print("키보드 올라옴")
                layoutTop()
            }
        }

        @objc private func keyboardWillHide(notification: NSNotification) {
            print("키보드 내려감")
            layoutMiddle()
        }

        deinit {
            NotificationCenter.default.removeObserver(self)
        }
    
    func layoutMiddle(){
        initialImageButtonConstraints.forEach { $0.priority = .defaultLow }
        roundBackgroundViewConstraints.forEach { $0.priority = .defaultLow }
        editCompleteButtonConstraints.forEach { $0.priority = .defaultLow }
        
       // `imageButton`의 새로운 제약조건을 생성하고 활성화
        leadingAnchor = imageButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -170)
       centerYAnchor = imageButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
       widthAnchor = imageButton.widthAnchor.constraint(equalToConstant: 134)
        heightAnchor = imageButton.heightAnchor.constraint(equalToConstant: 160)
        
        initialImageButtonConstraints = [leadingAnchor, centerYAnchor, widthAnchor, heightAnchor]
        NSLayoutConstraint.activate(initialImageButtonConstraints)
        

        leadingAnchor = roundBackgroundView.leadingAnchor.constraint(equalTo: imageButton.trailingAnchor, constant: 20)
        centerYAnchor = roundBackgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        widthAnchor = roundBackgroundView.widthAnchor.constraint(equalToConstant: 250)
        heightAnchor = roundBackgroundView.heightAnchor.constraint(equalToConstant: 160)

        roundBackgroundViewConstraints = [leadingAnchor, centerYAnchor, widthAnchor, heightAnchor]
        NSLayoutConstraint.activate(roundBackgroundViewConstraints)
        
        widthAnchor = editCompleteButton.widthAnchor.constraint(equalToConstant: 110)
        heightAnchor =  editCompleteButton.heightAnchor.constraint(equalToConstant: 40)
        bottomAnchor = editCompleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        trailingAnchor = editCompleteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -30)
        editCompleteButtonConstraints = [widthAnchor, heightAnchor, bottomAnchor, trailingAnchor]
       NSLayoutConstraint.activate(editCompleteButtonConstraints)
        

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func layoutTop(){
        initialImageButtonConstraints.forEach { $0.priority = .defaultLow }
        roundBackgroundViewConstraints.forEach { $0.priority = .defaultLow }
        editCompleteButtonConstraints.forEach { $0.priority = .defaultLow }
        
        
        // `imageButton`의 새로운 제약조건을 생성하고 활성화
         leadingAnchor = imageButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -170)
        topAnchor = imageButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40)
        widthAnchor = imageButton.widthAnchor.constraint(equalToConstant: 134)
         heightAnchor = imageButton.heightAnchor.constraint(equalToConstant: 160)
         
        initialImageButtonConstraints = [leadingAnchor, topAnchor, widthAnchor,heightAnchor]
         NSLayoutConstraint.activate(initialImageButtonConstraints)
         
         leadingAnchor = roundBackgroundView.leadingAnchor.constraint(equalTo: imageButton.trailingAnchor, constant: 20)
        topAnchor = roundBackgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40)
         widthAnchor = roundBackgroundView.widthAnchor.constraint(equalToConstant: 250)
         heightAnchor = roundBackgroundView.heightAnchor.constraint(equalToConstant: 160)

        roundBackgroundViewConstraints = [leadingAnchor, topAnchor, widthAnchor,heightAnchor]
         NSLayoutConstraint.activate(roundBackgroundViewConstraints)
        
        widthAnchor = editCompleteButton.widthAnchor.constraint(equalToConstant: 110)
        heightAnchor =  editCompleteButton.heightAnchor.constraint(equalToConstant: 40)
        centerYAnchor = editCompleteButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        trailingAnchor = editCompleteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -30)
        editCompleteButtonConstraints = [widthAnchor, heightAnchor, centerYAnchor, trailingAnchor]
       NSLayoutConstraint.activate(editCompleteButtonConstraints)
        
    

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    

}
