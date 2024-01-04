import UIKit

class SelectRowsColumnViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPickerViewDelegate, UIPickerViewDataSource {

    var studentNames: [String] = []
    let confirmButton = UIButton(type: .system)

    var gridColumns = 8 // Track the number of columns in the grid
    var boxes: [Bool] = Array(repeating: false, count: 64) // Initial 8x8 grid
    
    let teacherTable = UIView()
    
    let backGroundBox1 = UIView()
    let backGroundBox2 = UIView()

    let rowLabel = UILabel()
    let columnLabel = UILabel()

    let infoLabel = UILabel()
    let line = UIView()

    let overlayView = UIView()
    let customAlertView = UIView()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    lazy var rowPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()

    lazy var columnPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.backgroundGrey
        print(studentNames)
        setupViews()
        setupConstraints()
        // Set initial picker selection to 4
        rowPicker.selectRow(3, inComponent: 0, animated: false)
        columnPicker.selectRow(3, inComponent: 0, animated: false)
        setupInfoLabel()

        // Update the grid based on the initial selection
        updateSelectionFromPickers()
    }

    private func setupViews() {
        setupBackGroundBox()
        setupBackGroundBox2()
        view.addSubview(collectionView)
        view.addSubview(rowPicker)
        view.addSubview(columnPicker)
        view.addSubview(rowLabel)
        view.addSubview(columnLabel)
        setupTeacherTable()
        setupLabels()
        setupConfirmButton()
        setUpLine()

        setupNav() // Call the function to setup navigation bar

    }
    
    private func setupTeacherTable() {
        teacherTable.backgroundColor = UIColor.disabled // Change color to dark grey
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
    
    private func setUpLine() {
        line.backgroundColor = UIColor.hintGrey
        line.translatesAutoresizingMaskIntoConstraints = false
        line.layer.masksToBounds = true
        view.addSubview(line)
    }
    
    private func setupBackGroundBox() {
        backGroundBox1.backgroundColor = .white // Change color to dark grey
        backGroundBox1.translatesAutoresizingMaskIntoConstraints = false
        backGroundBox1.layer.cornerRadius = 10
        backGroundBox1.layer.masksToBounds = true
        view.addSubview(backGroundBox1)
    }
    
    private func setupBackGroundBox2() {
           backGroundBox2.backgroundColor = .white // Set the desired color
           backGroundBox2.translatesAutoresizingMaskIntoConstraints = false
           backGroundBox2.layer.cornerRadius = 10
           backGroundBox2.layer.masksToBounds = true
           view.addSubview(backGroundBox2)

           // Add any additional configuration for backGroundBox2 here if necessary
       }
    
    private func setupLabels() {
        rowLabel.text = "세로"
        rowLabel.textAlignment = .center
        rowLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        rowLabel.translatesAutoresizingMaskIntoConstraints = false

        columnLabel.text = "가로"
        columnLabel.textAlignment = .center
        columnLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        columnLabel.translatesAutoresizingMaskIntoConstraints = false

    }

    // MARK: - InfoLabel
    private func setupInfoLabel() {
        infoLabel.text = "좌석 값을 설정해주세요"
        infoLabel.textColor = UIColor.disabled
        infoLabel.textAlignment = .center
        infoLabel.font = UIFont.systemFont(ofSize: 14, weight: .light) // Set the font and size
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(infoLabel)
        
        // Constraints for the label to position it above backGroundBox2
        NSLayoutConstraint.activate([
            infoLabel.bottomAnchor.constraint(equalTo: backGroundBox2.topAnchor, constant: -12),
            infoLabel.centerXAnchor.constraint(equalTo: backGroundBox2.centerXAnchor),
        ])
    }

    //MARK: confirm btton and its actions
    private func setupConfirmButton() {
        confirmButton.setTitle("완료", for: .normal)
        confirmButton.backgroundColor = UIColor.mainYellow // Use a custom yellow color if needed
        confirmButton.setTitleColor(UIColor.black, for: .normal) // Set the text color
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium) // Set the font and size

        // To get the full rounded corners, set the cornerRadius to half of the height of the button.
        confirmButton.layer.cornerRadius = 22 // Assuming the height of your button is 44

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
        let selectedRow = rowPicker.selectedRow(inComponent: 0) + 1
        let selectedColumn = columnPicker.selectedRow(inComponent: 0) + 1
        let totalSeats = selectedRow * selectedColumn

        // Check if the student list needs to be filled with placeholders
        if studentNames.count < totalSeats {
            // Calculate the number of placeholders needed
            let placeholdersNeeded = totalSeats - studentNames.count

            // Append placeholders to the end of the studentNames list
            for _ in 0..<placeholdersNeeded {
                studentNames.append("-")
            }
        }
        
        // Proceed to the next view controller with the updated student list
        let gridDisplayVC = GridViewController(rows: selectedRow, columns: selectedColumn)
        gridDisplayVC.studentNames = studentNames
        navigationController?.pushViewController(gridDisplayVC, animated: true)
    }

    private func setupConstraints() {
        let spacing: CGFloat = 2
        let columnSpacing = (2 * spacing) + (CGFloat(gridColumns - 1) * spacing)

        let itemWidth = (view.bounds.width - columnSpacing) / CGFloat(gridColumns)
        let itemHeight = itemWidth - 5
        let numberOfRows = boxes.count / gridColumns
        let collectionViewHeight = (itemHeight * CGFloat(numberOfRows-2))

        let pickerWidth: CGFloat = 80 // Adjust as needed
        let pickerHeight: CGFloat = 140 // Adjust as needed

        NSLayoutConstraint.activate([
            
            backGroundBox1.bottomAnchor.constraint(equalTo: teacherTable.bottomAnchor, constant: 25),
            backGroundBox1.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            backGroundBox1.widthAnchor.constraint(equalToConstant: 343), // Set the width as needed
            backGroundBox1.heightAnchor.constraint(equalToConstant: 340),  // Set the height as needed
            
            backGroundBox2.topAnchor.constraint(equalTo: backGroundBox1.bottomAnchor, constant: 50),
            backGroundBox2.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            backGroundBox2.widthAnchor.constraint(equalToConstant: 343), // Set the width as needed
            backGroundBox2.heightAnchor.constraint(equalToConstant: 168),  // Set the height as needed
            
            //선생님 박스. 위치가 화면에 고정되어 있어 디바이스마다 다를수도..
            teacherTable.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * (3.5 / 7.0)),
            teacherTable.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            teacherTable.widthAnchor.constraint(equalToConstant: 100), // Set the width as needed
            teacherTable.heightAnchor.constraint(equalToConstant: 30),  // Set the height as needed
            
            collectionView.bottomAnchor.constraint(equalTo:  teacherTable.topAnchor, constant: -10),
//            collectionView.bottomAnchor.constraint(equalTo: rectangleBox.topAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            collectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight),

            rowLabel.trailingAnchor.constraint(equalTo: backGroundBox2.trailingAnchor, constant: -125),
            rowLabel.topAnchor.constraint(equalTo: backGroundBox2.topAnchor, constant: 15),

            columnLabel.leadingAnchor.constraint(equalTo: backGroundBox2.leadingAnchor, constant: 125),
            columnLabel.topAnchor.constraint(equalTo: backGroundBox2.topAnchor, constant: 15),
            
            line.topAnchor.constraint(equalTo: backGroundBox2.topAnchor, constant: 38),
            line.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            line.widthAnchor.constraint(equalToConstant: 294), // Set the width as needed
            line.heightAnchor.constraint(equalToConstant: 1),  // Set the height as needed
            
            
            rowPicker.trailingAnchor.constraint(equalTo: backGroundBox2.trailingAnchor, constant: -95),
            rowPicker.widthAnchor.constraint(equalToConstant: pickerWidth),
            rowPicker.heightAnchor.constraint(equalToConstant: pickerHeight),
            rowPicker.topAnchor.constraint(equalTo: backGroundBox1.bottomAnchor, constant: 80),
            
            columnPicker.leadingAnchor.constraint(equalTo: backGroundBox2.leadingAnchor, constant: 100),
            columnPicker.widthAnchor.constraint(equalToConstant: pickerWidth),
            columnPicker.heightAnchor.constraint(equalToConstant: pickerHeight),
            columnPicker.topAnchor.constraint(equalTo: backGroundBox1.bottomAnchor, constant: 80),


            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            confirmButton.widthAnchor.constraint(equalToConstant: 343), // Width of the button
            confirmButton.heightAnchor.constraint(equalToConstant: 44) // Height of the button
            
           
            
        ])
    }

    // UICollectionViewDelegate and DataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return boxes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = boxes[indexPath.row] ? UIColor.mainYellow : UIColor.hintGrey
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 2
        let totalSpacing = (2 * spacing) + (CGFloat(7) * spacing) // Spacing for 8 columns
        let width = (collectionView.bounds.width - totalSpacing) / 8 // Width for 8-column grid
        let height = width - 5
        return CGSize(width: width, height: height)
    }
    


    // UIPickerViewDelegate and DataSource Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 8
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateSelectionFromPickers()
    }

    func updateSelectionFromPickers() {
        let selectedRow = rowPicker.selectedRow(inComponent: 0) + 1
        let selectedColumn = columnPicker.selectedRow(inComponent: 0) + 1
        updateGridSize(selectedColumn: selectedColumn)

        // Clear previous selections
        boxes = Array(repeating: false, count: gridColumns * 8)

        // Calculate the starting and ending columns for highlighting
        let middleColumn = gridColumns / 2 // Central column index
        let columnsToLeft = selectedColumn / 2 // Integer division, rounds down for odd numbers
        let columnsToRight = selectedColumn / 2 + (selectedColumn % 2) // Adds 1 for odd numbers

        // Highlight the cells based on selection
        for row in (8 - selectedRow)..<8 {
            for col in (middleColumn - columnsToLeft)..<(middleColumn + columnsToRight) {
                if col >= 0 && col < gridColumns {
                    let index = row * gridColumns + col
                    if index < boxes.count {
                        boxes[index] = true
                    }
                }
            }
        }

        collectionView.reloadData()
    }


    func updateGridSize(selectedColumn: Int) {
        gridColumns = selectedColumn % 2 == 0 ? 8 : 7
        boxes = Array(repeating: false, count: gridColumns * 8)

        // Calculate the horizontal inset for centering the 7-column grid
        let spacing: CGFloat = 2
        let totalSpacing = (2 * spacing) + (CGFloat(7) * spacing) // For 8 columns
        let cellWidth = (collectionView.bounds.width - totalSpacing) / 8
        let totalCellWidth = cellWidth * CGFloat(gridColumns)
        let extraSpace = collectionView.bounds.width - totalCellWidth - totalSpacing
        let inset = extraSpace / 2

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: 0, left: max(inset, 0), bottom: 0, right: max(inset, 0))
        }

        collectionView.reloadData()
    }
    

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

}



