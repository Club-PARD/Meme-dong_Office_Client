import UIKit

class SelectRowsColumn: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPickerViewDelegate, UIPickerViewDataSource {

    let confirmButton = UIButton(type: .system)

    var gridColumns = 8 // Track the number of columns in the grid
    var boxes: [Bool] = Array(repeating: false, count: 64) // Initial 8x8 grid
    
    let teacherTable = UIView()
    let rowLabel = UILabel()
    let columnLabel = UILabel()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .backgroundGrey
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
        view.backgroundColor = .systemBackground
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        view.addSubview(collectionView)
        view.addSubview(rowPicker)
        view.addSubview(columnPicker)
        view.addSubview(rowLabel)
        view.addSubview(columnLabel)
        setupTeacherTable()
        setupLabels()
        setupConfirmButton()
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


    private func setupConfirmButton() {
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(confirmButton)
    }
    
    //confirm button UI and function
    @objc func confirmTapped() {
        let selectedRow = rowPicker.selectedRow(inComponent: 0) + 1
        let selectedColumn = columnPicker.selectedRow(inComponent: 0) + 1

        // Create gridDisplayVC using the custom initializer
//        let gridDisplayVC = GridDisplayViewController(rows: selectedRow, columns: selectedColumn)
        let gridDisplayVC = GridViewController(rows: selectedRow, columns: selectedColumn)

        // If using a navigation controller
        navigationController?.pushViewController(gridDisplayVC, animated: true)

        // Or, presenting the view controller modally
        // present(gridDisplayVC, animated: true, completion: nil)
    }

    private func setupLabels() {
        rowLabel.text = "Rows"
        rowLabel.textAlignment = .center
        rowLabel.translatesAutoresizingMaskIntoConstraints = false

        columnLabel.text = "Columns"
        columnLabel.textAlignment = .center
        columnLabel.translatesAutoresizingMaskIntoConstraints = false

    }

    private func setupConstraints() {
        let spacing: CGFloat = 2
        let columnSpacing = (2 * spacing) + (CGFloat(gridColumns - 1) * spacing)
        let rowSpacing = (2 * spacing) + (CGFloat(7) * spacing) // Assuming 8 rows, spacing for 7 gaps

        let itemWidth = (view.bounds.width - columnSpacing) / CGFloat(gridColumns)
        let itemHeight = itemWidth - 5
        let numberOfRows = boxes.count / gridColumns
        let collectionViewHeight = (itemHeight * CGFloat(numberOfRows)) + rowSpacing

        let pickerWidth: CGFloat = 80 // Adjust as needed

        NSLayoutConstraint.activate([
            
            //선생님 박스. 위치가 화면에 고정되어 있어 디바이스마다 다를수도..
            teacherTable.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * (3.5 / 7.0)),
            teacherTable.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            teacherTable.widthAnchor.constraint(equalToConstant: 100), // Set the width as needed
            teacherTable.heightAnchor.constraint(equalToConstant: 30),  // Set the height as needed
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
//            collectionView.bottomAnchor.constraint(equalTo: rectangleBox.topAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            collectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight),

            rowPicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            rowPicker.widthAnchor.constraint(equalToConstant: pickerWidth),
            rowPicker.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),

            rowLabel.trailingAnchor.constraint(equalTo: rowPicker.trailingAnchor),
            rowLabel.bottomAnchor.constraint(equalTo: rowPicker.topAnchor, constant: 5),

            columnPicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            columnPicker.widthAnchor.constraint(equalToConstant: pickerWidth),
            columnPicker.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),

            columnLabel.leadingAnchor.constraint(equalTo: columnPicker.leadingAnchor),
            columnLabel.bottomAnchor.constraint(equalTo: columnPicker.topAnchor, constant: 5),

            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
           
            
        ])
    }

    // UICollectionViewDelegate and DataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return boxes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = boxes[indexPath.row] ? UIColor.systemYellow : UIColor.gray
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
}
