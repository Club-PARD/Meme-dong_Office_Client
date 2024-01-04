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
    
     
     private let updatedBirthdateLabel: UILabel = {
         let label = UILabel()
         label.font = UIFont.systemFont(ofSize: 14)
         label.textColor = .black
          label.text = "birth"
         return label
     }()

     private let updatedAllergiesLabel: UILabel = {
         let label = UILabel()
         label.font = UIFont.systemFont(ofSize: 14)
         label.textColor = .black
          label.text = "aller"
         return label
     }()

     private let updatedOtherInfoLabel: UILabel = {
         let label = UILabel()
         label.font = UIFont.systemFont(ofSize: 14)
         label.textColor = .black
          label.text = "ㅁㄴㅇㄹㅁㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹ"
          label.numberOfLines = 0
         return label
     }()
     
     let birthView = UIView()
     let alleView = UIView()
     let otherInfoView = UIView()

    
    private var imageButton: UIButton = {
        let button = UIButton()
        if let image = UIImage(named: "Image") {
            button.setImage(image, for: .normal)
        }
        button.imageView?.contentMode = .scaleAspectFit
        button.clipsToBounds = true

        button.addTarget(self, action: #selector(imageButtonTapped), for: .touchUpInside)

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
    
    
    
     private var bottomSheetViewTopConstraint: NSLayoutConstraint!
    
    var index:Int
    
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
        setupUI()
        
        
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
            dimmedView.addGestureRecognizer(dimmedTap)
            dimmedView.isUserInteractionEnabled = true
        
        
    }
    
     
     private func setupUI(){
         
         studentNameLabel.text = classroomViewModel.classroom.studentsList?[index].name
         updatedAllergiesLabel.text = classroomViewModel.classroom.studentsList?[index].allergy
         updatedBirthdateLabel.text = classroomViewModel.classroom.studentsList?[index].birthday
         updatedOtherInfoLabel.text = classroomViewModel.classroom.studentsList?[index].etc
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
         
          bottomSheetView.addSubview(updatedAllergiesLabel)
          bottomSheetView.addSubview(updatedBirthdateLabel)
          bottomSheetView.addSubview(updatedOtherInfoLabel)
          
          bottomSheetView.addSubview(studentNameLabel)
          

          birthdateLabel.translatesAutoresizingMaskIntoConstraints = false
          allergiesLabel.translatesAutoresizingMaskIntoConstraints = false
          otherInfoLabel.translatesAutoresizingMaskIntoConstraints = false
          dimmedView.translatesAutoresizingMaskIntoConstraints = false
          roundBackgroundView.translatesAutoresizingMaskIntoConstraints = false
          closeButton.translatesAutoresizingMaskIntoConstraints = false
          
          birthView.translatesAutoresizingMaskIntoConstraints = false
          alleView.translatesAutoresizingMaskIntoConstraints = false
          otherInfoView.translatesAutoresizingMaskIntoConstraints = false
          
          updatedBirthdateLabel.translatesAutoresizingMaskIntoConstraints = false
          updatedAllergiesLabel.translatesAutoresizingMaskIntoConstraints = false
          updatedOtherInfoLabel.translatesAutoresizingMaskIntoConstraints = false
          
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
          
          NSLayoutConstraint.activate([
                  // Constraints for roundBackgroundView to define its position and size
                  roundBackgroundView.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor),
                  roundBackgroundView.bottomAnchor.constraint(equalTo: bottomSheetView.bottomAnchor, constant: -20), // Adjust this as needed
                  roundBackgroundView.widthAnchor.constraint(equalToConstant: 200), // Adjust this as needed
                  roundBackgroundView.heightAnchor.constraint(equalToConstant: 160), // Adjust this based on the content
              ])

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
               birthView.widthAnchor.constraint(equalToConstant: 110),
               
               alleView.leadingAnchor.constraint(equalTo: birthdateLabel.trailingAnchor, constant: 10),
               alleView.topAnchor.constraint(equalTo: allergiesLabel.topAnchor,constant: -2),
               alleView.widthAnchor.constraint(equalToConstant: 110),
               alleView.heightAnchor.constraint(equalToConstant: 20),
               
               otherInfoView.leadingAnchor.constraint(equalTo: birthdateLabel.trailingAnchor, constant: 10),
               otherInfoView.topAnchor.constraint(equalTo: otherInfoLabel.topAnchor,constant: -2),
               otherInfoView.bottomAnchor.constraint(equalTo: roundBackgroundView.bottomAnchor, constant: -10),
               otherInfoView.widthAnchor.constraint(equalToConstant: 110),
               
               updatedBirthdateLabel.leadingAnchor.constraint(equalTo: birthView.leadingAnchor, constant: 10),
               updatedBirthdateLabel.topAnchor.constraint(equalTo: birthdateLabel.topAnchor),
                  
               updatedAllergiesLabel.leadingAnchor.constraint(equalTo: alleView.leadingAnchor, constant: 10),
               updatedAllergiesLabel.topAnchor.constraint(equalTo: allergiesLabel.topAnchor),
                  
               updatedOtherInfoLabel.leadingAnchor.constraint(equalTo: alleView.leadingAnchor, constant: 10),
               updatedOtherInfoLabel.topAnchor.constraint(equalTo: otherInfoLabel.topAnchor),
               updatedOtherInfoLabel.trailingAnchor.constraint(equalTo: otherInfoView.trailingAnchor, constant: -10),
          ])

          
         NSLayoutConstraint.activate([
             dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
             dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
         ])
        
         imageButton.translatesAutoresizingMaskIntoConstraints = false
          
          NSLayoutConstraint.activate([
            imageButton.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 41),
            imageButton.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: -40),
            imageButton.heightAnchor.constraint(equalToConstant: 130)
          ])
          
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
         hideBottomSheetAndGoBack()
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

     @objc private func editButtonTapped() {
         let alertController = UIAlertController(title: "정보 수정", message: nil, preferredStyle: .alert)

         alertController.addTextField { textField in
             textField.placeholder = "생년월일"
             textField.text = ""
         }
         alertController.addTextField { textField in
             textField.placeholder = "알레르기"
             textField.text = ""
         }
         alertController.addTextField { textField in
             textField.placeholder = "기타"
             textField.text = ""
         }

          let saveAction = UIAlertAction(title: "저장", style: .default) { [weak self] _ in
               guard let self = self else { return }
               let birthdateText = alertController.textFields?[0].text ?? ""
               let allergiesText = alertController.textFields?[1].text ?? ""
               let otherInfoText = alertController.textFields?[2].text ?? ""
               
               // 새로운 라벨들 업데이트
               self.updatedBirthdateLabel.text = birthdateText
               self.updatedAllergiesLabel.text = allergiesText
               self.updatedOtherInfoLabel.text = otherInfoText
          }

         let cancelAction = UIAlertAction(title: "취소", style: .cancel)

         alertController.addAction(saveAction)
         alertController.addAction(cancelAction)

         self.present(alertController, animated: true)
     }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

}
