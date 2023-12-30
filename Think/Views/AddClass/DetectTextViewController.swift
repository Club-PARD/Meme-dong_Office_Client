import UIKit
import Vision




class DetectTextViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let cameraHandler = CameraHandler.shared
    
    var imageView: UIImageView!
    var incomingImage: UIImage?
    //var overlayView: UIView!
    var textObservations = [VNRecognizedTextObservation]()
    var studentNameList = [String]()
    
    let bottomSheetVC = AddBottomSheetViewController()
    let scrollView: UIScrollView = UIScrollView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        view.backgroundColor = .white
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
        ])
        
        
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        //view.addSubview(imageView)
        scrollView.addSubview(imageView)
        
        setupImageViewConstraints()
        
        setupBottomSheet()
    }
    
    func updateImageView(with image: UIImage) {
        self.incomingImage = image
        self.imageView.image = image
        // 필요한 경우 텍스트 인식 과정을 여기에서 다시 수행
        detectText(from: image)
    }
    

    func setupNav(){
        self.navigationItem.title = "추가하기"
    }
    
    func setupImageViewConstraints() {
        if let imageToDetect = incomingImage {
            imageView.image = imageToDetect

            // 이미지의 원본 비율에 따라 imageView의 높이를 계산합니다.
            let imageAspectRatio = imageToDetect.size.height / imageToDetect.size.width
            let imageViewHeight = view.frame.width * imageAspectRatio

            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                imageView.heightAnchor.constraint(equalToConstant: imageViewHeight),
                imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            ])

            // 스크롤 뷰의 contentSize를 계산합니다.
            // 이미지 뷰의 높이와 추가적인 400픽셀 높이를 더합니다.
            let scrollHeight = view.frame.height * 0.4
            let totalContentHeight = imageViewHeight + scrollHeight
            scrollView.contentSize = CGSize(width: view.frame.width, height: totalContentHeight)

            // 이미지 뷰의 bottomAnchor를 스크롤 뷰의 bottomAnchor에 연결합니다.
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -scrollHeight).isActive = true

            detectText(from: imageToDetect)
        }
    }



    
    
    func detectText(from image: UIImage) {
        // 이미지의 방향을 올바르게 조정합니다.
        guard let correctlyOrientedImage = image.correctlyOrientedImage(),
              let cgImage = correctlyOrientedImage.cgImage else {
            print("Could not correct the image orientation.")
            return
        }

        // Vision 텍스트 인식 요청을 생성합니다.
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
                print("Text recognition error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.main.async {
                // 인식된 텍스트 관찰 결과를 처리합니다.
                self?.textObservations = observations
                // 인식된 텍스트 위에 오버레이를 배치하는 함수를 호출합니다.
                self?.placeTextSelectionOverlays(observations: observations)
            }
        }
        // 텍스트 인식 요청에 사용할 언어를 설정합니다.
        request.recognitionLanguages = ["ko-KR"]
        request.usesLanguageCorrection = true
        
        // Vision 이미지 요청 핸들러를 생성하고 텍스트 인식 요청을 수행합니다.
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])
    }
    
    func placeTextSelectionOverlays(observations: [VNRecognizedTextObservation]) {
        guard let imageSize = imageView.image?.size else { return }
        let viewSize = imageView.bounds.size

        // 이미지가 실제로 차지하는 영역을 계산합니다.
        let scale = min(viewSize.width / imageSize.width, viewSize.height / imageSize.height)
        let offsetX = (viewSize.width - imageSize.width * scale) / 2
        let offsetY = (viewSize.height - imageSize.height * scale) / 2
        
        
        let scaledImageWidth = imageSize.width * scale
        let scaledImageHeight = imageSize.height * scale
        let imageRect = CGRect(
            x: (viewSize.width - scaledImageWidth) / 2,
            y: (viewSize.height - scaledImageHeight) / 2,
            width: scaledImageWidth,
            height: scaledImageHeight
        )

        // 이전 오버레이 제거
        imageView.subviews.forEach({ $0.removeFromSuperview() })

        // 회색 오버레이 뷰를 이미지가 실제로 차지하는 영역에만 적용합니다.
        let overlayView = UIView(frame: imageRect)
        overlayView.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
        imageView.addSubview(overlayView)

        // 텍스트 영역을 제외하는 경로 생성
        let path = UIBezierPath(rect: overlayView.bounds)
        for observation in observations {
            let boundingBox = observation.boundingBox
            let x = boundingBox.origin.x * scaledImageWidth
            let y = (1 - boundingBox.origin.y - boundingBox.height) * scaledImageHeight
            let width = boundingBox.width * scaledImageWidth
            let height = boundingBox.height * scaledImageHeight

            let textRect = CGRect(x: x, y: y, width: width, height: height)
            path.append(UIBezierPath(rect: textRect))
        }

        // 마스크 레이어 생성 및 설정
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        maskLayer.fillRule = .evenOdd
        overlayView.layer.mask = maskLayer

        // 텍스트 버튼 추가
        
                for (index, observation) in observations.enumerated() {
                    let boundingBox = observation.boundingBox
                    let x = boundingBox.origin.x * imageSize.width * scale + offsetX
                    let y = (1 - boundingBox.origin.y - boundingBox.height) * imageSize.height * scale + offsetY
                    let width = boundingBox.width * imageSize.width * scale
                    let height = boundingBox.height * imageSize.height * scale

                    let textButton = UIButton(frame: CGRect(x: x, y: y, width: width, height: height))
                    textButton.backgroundColor = .clear
                    textButton.layer.borderColor = UIColor.clear.cgColor
                    textButton.layer.borderWidth = 2
                    textButton.layer.cornerRadius = 5
                    textButton.layer.masksToBounds = true
                    textButton.tag = index // 각 버튼에 고유한 태그 할당
                    textButton.addTarget(self, action: #selector(textTapped(_:)), for: .touchUpInside)
                    imageView.addSubview(textButton)
                }

    }







    @objc func textTapped(_ sender: UIButton) {
        let index = sender.tag // 버튼의 태그를 인덱스로 사용
            guard index < textObservations.count else { return }

            let selectedTextObservation = textObservations[index]
            guard let topCandidate = selectedTextObservation.topCandidates(1).first else { return }
        
               if sender.backgroundColor == .clear {
                   sender.backgroundColor = UIColor.yellow.withAlphaComponent(0.3)
                   studentNameList.append(topCandidate.string)
               } else {
                   sender.backgroundColor = .clear
                   studentNameList.removeAll { $0 == topCandidate.string }
               }
    
        
        print("Selected text: \(topCandidate.string)")
        print(studentNameList)
        bottomSheetVC.updateStudentNameLabel(with: studentNameList)
    }
    
    func setupBottomSheet(){
        addChild(bottomSheetVC)
        view.addSubview(bottomSheetVC.view)
        bottomSheetVC.didMove(toParent: self)
        
        let height = view.frame.height * 0.4
        bottomSheetVC.view.frame = CGRect(x: 0, y: view.frame.height-height, width: view.frame.width, height: height)
        
        // Bottom Sheet 뷰를 전체 화면의 너비로 설정합니다.
        bottomSheetVC.view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleTopMargin]

        
    }
}



class AddBottomSheetViewController: UIViewController {
    
    var studentNameList = [String]()
    let cameraHandler = CameraHandler.shared
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "선택된 학생 명단"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    let additionalAddButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("추가 촬영 및 업로드", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        
        button.addTarget(self, action: #selector(additionalAddButtonAction), for: .touchUpInside)
        
        return button
    }()
    
    let additionalLabel: UILabel = {
        let label = UILabel()
        label.text = "추가 촬영을 원하시면 버튼을 눌러서 명단을 추가해주세요!"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .gray
        
        return label
    }()
    
    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다음", for: .normal)
        button.tintColor = .black
        //button.backgroundColor = UIColor(red: 1.0, green: 214/255, blue: 0.0, alpha: 1.0)
        button.layer.cornerRadius = 20.5
        button.layer.borderWidth = 2
        button.layer.borderColor = CGColor(red: 1.0, green: 84, blue: 0.0, alpha: 1.0)
        //button.titleLabel?.font = UIFont(name: "Pretendard", size: 17)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold).self
        button.addTarget(BottomSheetViewController.self, action: #selector(nextButtonAction), for: .touchUpInside)
        
        return button
    }()
    
    var selectedStudentNameLabel:UILabel = UILabel()
    
    @objc func nextButtonAction(){
        let sortedStudentNameList = studentNameList.sorted { $0.localizedCompare($1) == .orderedAscending }
        print(sortedStudentNameList)
    }
    
    @objc func additionalAddButtonAction(){
        cameraHandler.currentViewController = self // 현재 뷰 컨트롤러 참조 설정
        cameraHandler.detectTextViewController = self.parent as? DetectTextViewController
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "카메라", style: .default) { _ in
                self.cameraHandler.openCamera()
            }
            alertController.addAction(cameraAction)
        }
        
        let galleryAction = UIAlertAction(title: "사진 보관함", style: .default) { _ in
            self.cameraHandler.openPhotoLibrary()
        }
        alertController.addAction(galleryAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBottomSheet()
        setupUI()
    }
    
    func setupUI(){
        view.addSubview(titleLabel)
        view.addSubview(selectedStudentNameLabel)
        view.addSubview(additionalLabel)
        view.addSubview(additionalAddButton)
        view.addSubview(nextButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        selectedStudentNameLabel.translatesAutoresizingMaskIntoConstraints = false
        additionalLabel.translatesAutoresizingMaskIntoConstraints = false
        additionalAddButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        selectedStudentNameLabel.numberOfLines = 6
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            selectedStudentNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            selectedStudentNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            selectedStudentNameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            //selectedStudentNameLabel.heightAnchor.constraint(equalToConstant: 40),
            additionalAddButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            additionalAddButton.bottomAnchor.constraint(equalTo: additionalLabel.topAnchor, constant: -5),
            additionalLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            additionalLabel.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -20),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 343),
            nextButton.heightAnchor.constraint(equalToConstant: 43)
        ])
        
    }
    
    private func setupBottomSheet() {
        view.backgroundColor = .white
    }
    
    func updateStudentNameLabel(with names: [String]) {
            let nameString = names.joined(separator: "   ")
            selectedStudentNameLabel.text = nameString
            studentNameList = names
        }
    
}


extension UIImage {
    func correctlyOrientedImage() -> UIImage? {
        if imageOrientation == .up {
            return self
        }

        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: CGRect(origin: .zero, size: size))
        let correctedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return correctedImage
    }
}




extension UIViewController {
    @objc func injected() {
        viewDidLoad()
    }
}
