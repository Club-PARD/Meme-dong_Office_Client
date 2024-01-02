import UIKit

class GridViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        configureUI()
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        view.backgroundColor = .hintGrey
        setupBackGroundBox()    // Setup for backGroundBox1
        setupBackGroundBox2()   // Setup for backGroundBox2
        setupTeacherTable()

        setupCollectionView()

        if gridColumns % 2 == 0 {
            setupButtons()
        }
        setupConfirmButton()
        setupConstraints()
    }
    
    private func setupConfirmButton() {
        confirmButton.setTitle("완료", for: .normal)
        confirmButton.backgroundColor = UIColor.systemYellow // Use a custom yellow color if needed
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

        let gridDisplayVC = GridViewController()

        // If using a navigation controller
        navigationController?.pushViewController(gridDisplayVC, animated: true)

        // Or, presenting the view controller modally
        // present(gridDisplayVC, animated: true, completion: nil)
    }
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
    
    
    private func setupButtons() {
        configureButton(buttonOne, title: "One")
        buttonOne.addTarget(self, action: #selector(adjustSpacingForOneButton), for: .touchUpInside)
        
        configureButton(buttonTwo, title: "Two")
        buttonTwo.addTarget(self, action: #selector(adjustSpacingForTwoButton), for: .touchUpInside)
    }
    
    
    @objc private func adjustSpacingForOneButton() {
        if let layout = collectionView.collectionViewLayout as? CustomGridLayout {
            layout.useAlternatingSpacing = false
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }

    @objc private func adjustSpacingForTwoButton() {
        if let layout = collectionView.collectionViewLayout as? CustomGridLayout {
            // Toggle alternating spacing
            layout.useAlternatingSpacing = true
            // Invalidate the layout to apply changes
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    private func configureButton(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
    }
    
    private func setupCollectionView() {
        let layout = CustomGridLayout(columns: gridColumns)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
    
    }
    
    
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
            backGroundBox2.heightAnchor.constraint(equalToConstant: 168),  // Set the height as needed
        ])
        
        if layout.gridColumns % 2 == 0 {
            // Set up constraints for the buttons only if they are added to the view
            NSLayoutConstraint.activate([
                buttonOne.topAnchor.constraint(equalTo: backGroundBox2.topAnchor, constant: 20),
                buttonOne.leadingAnchor.constraint(equalTo: backGroundBox2.leadingAnchor, constant: 120),
                buttonTwo.trailingAnchor.constraint(equalTo: backGroundBox2.trailingAnchor, constant: -120),
                buttonTwo.topAnchor.constraint(equalTo: backGroundBox2.topAnchor, constant: 20),
            ])
        }
    }
    
    // UICollectionViewDataSource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gridRows * gridColumns
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.systemYellow // All cells are highlighted
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        return cell
    }
    
}
