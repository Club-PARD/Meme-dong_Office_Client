import UIKit

class SelectRowsColumn: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPickerViewDelegate, UIPickerViewDataSource {

    let confirmButton = UIButton(type: .system)

    var gridColumns = 8 // Track the number of columns in the grid
    var boxes: [Bool] = Array(repeating: false, count: 64) // Initial 8x8 grid
    
    let rectangleBox = UIView()
    let rowLabel = UILabel()
    let columnLabel = UILabel()
    let selectionLabel = UILabel()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
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
        view.addSubview(selectionLabel)
        setupRectangleBox()
        setupLabels()
        setupConfirmButton()
    }
    
    private func setupRectangleBox() {
        rectangleBox.backgroundColor = .red
        rectangleBox.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rectangleBox)
    }

    private func setupConfirmButton() {
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(confirmButton)
    }

    private func setupLabels() {
        rowLabel.text = "Rows"
        rowLabel.textAlignment = .center
        rowLabel.translatesAutoresizingMaskIntoConstraints = false

        columnLabel.text = "Columns"
        columnLabel.textAlignment = .center
        columnLabel.translatesAutoresizingMaskIntoConstraints = false

        selectionLabel.textAlignment = .center
        selectionLabel.textColor = .black
        selectionLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupConstraints() {
        let spacing: CGFloat = 2
        let totalSpacing = (2 * spacing) + (CGFloat(gridColumns - 1) * spacing)
        let width = (view.bounds.width - totalSpacing) / CGFloat(gridColumns)
        let collectionViewHeight = width * CGFloat(gridColumns) + CGFloat(gridColumns - 1) * spacing
        let pickerWidth: CGFloat = 80 // Adjust as needed

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            collectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight),

            rowPicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            rowPicker.widthAnchor.constraint(equalToConstant: pickerWidth),
            rowPicker.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),

            rowLabel.trailingAnchor.constraint(equalTo: rowPicker.trailingAnchor),
            rowLabel.topAnchor.constraint(equalTo: rowPicker.bottomAnchor, constant: 5),

            columnPicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            columnPicker.widthAnchor.constraint(equalToConstant: pickerWidth),
            columnPicker.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),

            columnLabel.leadingAnchor.constraint(equalTo: columnPicker.leadingAnchor),
            columnLabel.topAnchor.constraint(equalTo: columnPicker.bottomAnchor, constant: 5),

            selectionLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            selectionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            //선생님 박스. 위치가 화면에 고정되어 있어 디바이스마다 다를수도..
            rectangleBox.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * (3.5 / 7.0)),
            rectangleBox.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            rectangleBox.widthAnchor.constraint(equalToConstant: 100), // Set the width as needed
            rectangleBox.heightAnchor.constraint(equalToConstant: 30)  // Set the height as needed
            
        ])
    }

    // UICollectionViewDelegate and DataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return boxes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = boxes[indexPath.row] ? UIColor.blue : UIColor.gray
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 2
        let totalSpacing = (2 * spacing) + (CGFloat(7) * spacing) // Spacing for 8 columns
        let width = (collectionView.bounds.width - totalSpacing) / 8 // Width for 8-column grid
        return CGSize(width: width, height: width)
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
        updateSelectionLabel()
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

    func updateSelectionLabel() {
        let selectedRow = rowPicker.selectedRow(inComponent: 0) + 1
        let selectedColumn = columnPicker.selectedRow(inComponent: 0) + 1
        selectionLabel.text = "Selected Rows: \(selectedRow), Selected Columns: \(selectedColumn)"
    }
}

