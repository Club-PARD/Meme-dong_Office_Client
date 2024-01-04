import UIKit

class GridViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - List of names
    var studentNames: [String] = []
    var oneOrTwo = false
    // MARK: - Properties
    let teacherTable = UIView()
    var gridColumns: Int
    var gridRows: Int
    var boxes: [Bool]
    let buttonOne = UIButton(type: .system)
    let buttonTwo = UIButton(type: .system)
    var collectionView: UICollectionView!
    let backGroundBox1 = UIView()
    let backGroundBox2 = UIView()
    let confirmButton = UIButton(type: .system)

    //sorting 관련
    let imageButton = UIButton(type: .system)
    let imageButton2 = UIButton(type: .system)
    var straightOrMixed = false

   

    
    
    // MARK: - Initializer
    init(rows: Int, columns: Int) {
        self.gridRows = rows
        self.gridColumns = columns
        self.boxes = Array(repeating: false, count: rows * columns)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(studentNames)
        configureUI()
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        view.backgroundColor = .hintGrey
        setupNav()
        setupBackGroundBox()
        setupBackGroundBox2()
        setupTeacherTable()

        setupCollectionView()

        if gridColumns % 2 == 0 {
            setupButtons()
        }
        setupConfirmButton()
        setupImageButton()
        setupConstraints()
    }
    // MARK: - Collection view
    private func setupCollectionView() {
        let layout = CustomGridLayout(columns: gridColumns)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
    
    }
    
    // MARK: - ConfirmButton
    private func setupConfirmButton() {
        confirmButton.setTitle("시작하기", for: .normal)
        confirmButton.backgroundColor = UIColor.mainYellow
        confirmButton.setTitleColor(UIColor.black, for: .normal) // Set the text color
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium) // Set the font and size
        confirmButton.layer.cornerRadius = 22

        // Set shadows if needed
        confirmButton.layer.shadowColor = UIColor.black.cgColor
        confirmButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        confirmButton.layer.shadowRadius = 4
        confirmButton.layer.shadowOpacity = 0.1
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)

        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(confirmButton)
    }
    
    //confirm button UI and function
    @objc func confirmTapped() {
        sort()
        let tempDisplayVC = TempHomeViewController()
        sendDataToServer()
        // If using a navigation controller
        navigationController?.pushViewController(tempDisplayVC, animated: true)

    }
    
    func sort() {
        let studentList = studentNames
        var sorted:[[String]] = []
        var combinedList:[String] = []
    
        //2. col 만큼 자르기
        for i in stride(from: 0, to: studentList.count, by:gridColumns){
            let endIndex = i+gridColumns
            sorted.append(Array(studentList[i..<endIndex]))
        }
        
        sorted = Array(sorted.reversed())
        
        if straightOrMixed == true {
            //case1
            // ㅎ<---
            //      |
            //  ----
            // |
            // ---- ㄱ
            
            if gridRows%2 == 0{
                for i in stride(from: 0, to: gridRows, by: 1){
                    if i%2==1{
                        sorted[i] = Array(sorted[i].reversed())
                    }
                }
            }
            else{
                for i in stride(from: 0, to: gridRows, by: 1){
                    if i%2==1{
                        sorted[i] = Array(sorted[i].reversed())
                    }
                }
            }

        }
        else if straightOrMixed == false {
            //ㅎ<---
            //---
            //---ㄱ
            for i in stride(from: 0, to: gridRows, by: 1){
                sorted[i] = Array(sorted[i].reversed())
            }
            
        }
        
        combinedList = sorted.reduce([],+)
    }
    
    // MARK: - BackgroundBoxes
    private func setupBackGroundBox() {
        backGroundBox1.backgroundColor = .white
        backGroundBox1.translatesAutoresizingMaskIntoConstraints = false
        backGroundBox1.layer.cornerRadius = 10
        backGroundBox1.layer.masksToBounds = true
        view.addSubview(backGroundBox1)
    }

    private func setupBackGroundBox2() {
        backGroundBox2.backgroundColor = .white
        backGroundBox2.translatesAutoresizingMaskIntoConstraints = false
        backGroundBox2.layer.cornerRadius = 10
        backGroundBox2.layer.masksToBounds = true
        view.addSubview(backGroundBox2)
    }

    
    private func setupTeacherTable() {
        teacherTable.backgroundColor = .darkGray // Change color to dark grey
        teacherTable.translatesAutoresizingMaskIntoConstraints = false
        teacherTable.layer.cornerRadius = 10
        teacherTable.layer.masksToBounds = true
        view.addSubview(teacherTable)

        // Create and setup the label
        let boxLabel = UILabel()
        boxLabel.text = "교탁" // Replace with your actual label text
        boxLabel.textColor = .white // Set the text color that contrasts well with dark grey
        boxLabel.textAlignment = .center
        boxLabel.translatesAutoresizingMaskIntoConstraints = false
        teacherTable.addSubview(boxLabel) // Add the label to the rectangleBox

        // Constraints for the label to center it within rectangleBox
        NSLayoutConstraint.activate([
            boxLabel.centerXAnchor.constraint(equalTo: teacherTable.centerXAnchor),
            boxLabel.centerYAnchor.constraint(equalTo: teacherTable.centerYAnchor)
        ])
    }
    
    
    // MARK: - Two buttons
    private func setupButtons() {
        configureButton(buttonOne, title: "1줄")
        buttonOne.addTarget(self, action: #selector(adjustSpacingForOneButton), for: .touchUpInside)
        
        configureButton(buttonTwo, title: "2줄")
        buttonTwo.addTarget(self, action: #selector(adjustSpacingForTwoButton), for: .touchUpInside)

        updateButtonAppearance() // Call this to initially set the correct colors based on the current state
    }

    @objc private func adjustSpacingForOneButton() {
        if let layout = collectionView.collectionViewLayout as? CustomGridLayout {
            layout.useAlternatingSpacing = false
            oneOrTwo = false
            collectionView.collectionViewLayout.invalidateLayout()
            updateButtonAppearance()
        }
    }

    @objc private func adjustSpacingForTwoButton() {
        if let layout = collectionView.collectionViewLayout as? CustomGridLayout {
            layout.useAlternatingSpacing = true
            oneOrTwo = true
            collectionView.collectionViewLayout.invalidateLayout()
            updateButtonAppearance()
        }
    }

    private func updateButtonAppearance() {
        if let layout = collectionView.collectionViewLayout as? CustomGridLayout {
            if layout.useAlternatingSpacing {
                // Case when useAlternatingSpacing is true
                buttonOne.backgroundColor = UIColor.white
                buttonOne.layer.borderWidth = 1 // Set the width of the border
                buttonOne.layer.borderColor = UIColor.hintGrey.cgColor // Set the color of the border
                
                buttonTwo.backgroundColor = UIColor.mainYellow
                buttonTwo.layer.borderWidth = 0 // Set the width of the border
            } else {
                // Case when useAlternatingSpacing is false
                buttonOne.backgroundColor = UIColor.mainYellow
                buttonOne.layer.borderWidth = 0 // Set the width of the border

                buttonTwo.backgroundColor = UIColor.white
                buttonTwo.layer.borderWidth = 1
                buttonTwo.layer.borderColor = UIColor.hintGrey.cgColor
            }
        }
    }

    private func configureButton(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        // The initial background color will be set by updateButtonAppearance
        button.setTitleColor(UIColor.black, for: .normal) // Set the text color
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium) // Set the font and size
        button.layer.cornerRadius = 16 // Assuming the height of your button is 44
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
    }
    
    
    // MARK: - Image Buttons
    private func setupImageButton() {
        view.addSubview(imageButton)
        configureImageButton(imageButton, imageNormal: "sortingOption")
        imageButton.addTarget(self, action: #selector(imageButtonTapped), for: .touchUpInside)
        imageButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(imageButton2)
        configureImageButton(imageButton2, imageNormal: "sortingOption 1")
        imageButton2.addTarget(self, action: #selector(imageButton2Tapped), for: .touchUpInside)
        imageButton2.translatesAutoresizingMaskIntoConstraints = false
        
        updateImageButtonAppearance()
    }

    
    private func configureImageButton(_ button: UIButton, imageNormal: String, imageHighlighted: String? = nil) {
        if let normalImage = UIImage(named: imageNormal) {
            button.setImage(normalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        if let highlightedImageName = imageHighlighted, let highlightedImage = UIImage(named: highlightedImageName) {
            button.setImage(highlightedImage.withRenderingMode(.alwaysOriginal), for: .highlighted)
        }
    }

    
    @objc private func imageButtonTapped() {
        straightOrMixed.toggle()
        updateImageButtonAppearance()
    }

    @objc private func imageButton2Tapped() {
        straightOrMixed.toggle()
        updateImageButtonAppearance()
    }
    
    private func updateImageButtonAppearance() {
        // Define the image names for the normal and clicked states
        let imageNormal = "sortingOption"
        let imageClicked = "sortingOption_Clicked"
        let imageNormal2 = "sortingOption 1"
        let imageClicked2 = "sortingOption 1_Clicked"

        if straightOrMixed {
            // Case when straightOrMixed is true
            imageButton.setImage(UIImage(named: imageNormal)?.withRenderingMode(.alwaysOriginal), for: .normal)
            imageButton2.setImage(UIImage(named: imageClicked2)?.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            // Case when straightOrMixed is false
            imageButton.setImage(UIImage(named: imageClicked)?.withRenderingMode(.alwaysOriginal), for: .normal)
            imageButton2.setImage(UIImage(named: imageNormal2)?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }

    
    // MARK: - Constraints
    private func setupConstraints() {
        guard let layout = collectionView.collectionViewLayout as? CustomGridLayout else {
            return
        }

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // Use properties from CustomGridLayout for totalCellWidth and totalCellHeight
        let spacenum = CGFloat(layout.gridColumns) - 1
        let totalCellWidth = (layout.cellSize.width * CGFloat(layout.gridColumns)) + (layout.baseSpacing * spacenum)
        let totalCellHeight = (layout.cellSize.height * CGFloat(gridRows)) + (layout.baseHeight * CGFloat(gridRows - 1))
        
        NSLayoutConstraint.activate([
            teacherTable.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * (3.3 / 7.0)),
            teacherTable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            teacherTable.widthAnchor.constraint(equalToConstant: 100),
            teacherTable.heightAnchor.constraint(equalToConstant: 30),
            
            collectionView.widthAnchor.constraint(equalToConstant: totalCellWidth),
            collectionView.heightAnchor.constraint(equalToConstant: totalCellHeight),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.bottomAnchor.constraint(equalTo: teacherTable.topAnchor, constant: -20),
            
            backGroundBox1.bottomAnchor.constraint(equalTo: teacherTable.bottomAnchor, constant: 20),
            backGroundBox1.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            backGroundBox1.widthAnchor.constraint(equalToConstant: 360), // Set the width as needed
            backGroundBox1.heightAnchor.constraint(equalToConstant: 300),  // Set the height as needed
            
            backGroundBox2.topAnchor.constraint(equalTo: backGroundBox1.bottomAnchor, constant: 50),
            backGroundBox2.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            backGroundBox2.widthAnchor.constraint(equalToConstant: 360), // Set the width as needed
            backGroundBox2.heightAnchor.constraint(equalToConstant: 180),  // Set the height as needed
            
            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            confirmButton.widthAnchor.constraint(equalToConstant: 340), // Width of the button
            confirmButton.heightAnchor.constraint(equalToConstant: 44), // Height of the button
            
            imageButton.bottomAnchor.constraint(equalTo: backGroundBox2.bottomAnchor, constant: -20),
            imageButton.leadingAnchor.constraint(equalTo: backGroundBox2.leadingAnchor, constant: 90),
            imageButton.widthAnchor.constraint(equalToConstant: 80),
            imageButton.heightAnchor.constraint(equalToConstant: 80),
            
            imageButton2.bottomAnchor.constraint(equalTo: backGroundBox2.bottomAnchor, constant: -20),
            imageButton2.trailingAnchor.constraint(equalTo: backGroundBox2.trailingAnchor, constant: -90),
            imageButton2.widthAnchor.constraint(equalToConstant: 80),
            imageButton2.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        if layout.gridColumns % 2 == 0 {
            // Set up constraints for the buttons only if they are added to the view
            NSLayoutConstraint.activate([
                buttonOne.topAnchor.constraint(equalTo: backGroundBox2.topAnchor, constant: 20),
                buttonOne.leadingAnchor.constraint(equalTo: backGroundBox2.leadingAnchor, constant: 110),
                buttonOne.widthAnchor.constraint(equalToConstant: 60), // Width of the button
                buttonOne.heightAnchor.constraint(equalToConstant: 30),
                // Height of the button
                buttonTwo.trailingAnchor.constraint(equalTo: backGroundBox2.trailingAnchor, constant: -110),
                buttonTwo.topAnchor.constraint(equalTo: backGroundBox2.topAnchor, constant: 20),
                buttonTwo.widthAnchor.constraint(equalToConstant: 60), // Width of the button
                buttonTwo.heightAnchor.constraint(equalToConstant: 30),
            ])
        }
    }
    
    // MARK: - Collection View Settings
    // UICollectionViewDataSource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gridRows * gridColumns
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.mainYellow // All cells are highlighted
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        return cell
    }
    
    // MARK: - Navigation Bar
    // 전환된 화면에 viewDidLoad 에 추가해줄 nav 함수
    func setupNav() {
        navigationItem.title = "추가하기"
        
        // iOS 15 styling
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.white
        appearance.shadowColor = nil
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // MARK: - API 연결 (이름 맞추기)
    struct StudentsListRequest: Codable {
        var name: String
        var listRow: Int
        var listCol: Int
        var seatSpacing: Bool
        var studentsList: [StudentInfo]
    }

    struct StudentInfo: Codable {
        var name: String
        var imageURL: String
        var birthday: String
        var allergy: String
        var studyLevel: String
        var etc: String
        var caution: Bool
    }

    // MARK: - JSON으로 변환
    func convertDataToJSON() -> Data? {
        // Assuming you have a method to create an array of StudentInfo from studentNames
        let studentsInfo = studentNames.map { name -> StudentInfo in
            return StudentInfo(
                name: name,
                imageURL: "", // Assuming we don't have image URLs
                birthday: "",
                allergy: "",
                studyLevel: "",
                etc: "",
                caution: false // Assuming we don't have this information
            )
        }

        let request = StudentsListRequest(
            name: "YourName", // Replace with actual name if needed
            listRow: gridRows,
            listCol: gridColumns,
            seatSpacing: oneOrTwo,
            studentsList: studentsInfo
        )

        do {
            let jsonData = try JSONEncoder().encode(request)
            return jsonData
        } catch {
            print("Error encoding data: \(error)")
            return nil
        }
    }
    
    // MARK: - 서버로 보내기
    func sendDataToServer() {
        guard let url = URL(string: "http://13.125.210.242:8080/api/v1/students/list") else { return }
        guard let jsonData = convertDataToJSON() else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 토큰 매니져에서 불러주기
        if let accessToken = TokenManager.shared.getAccessToken() {
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            print("Error: Access token is not available.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending data to server: \(error)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("HTTP Error: \(httpResponse.statusCode)")
                return
            }
            // Handle response data if needed
            print("Data sent successfully.")
        }
        
        task.resume()
    }


}
