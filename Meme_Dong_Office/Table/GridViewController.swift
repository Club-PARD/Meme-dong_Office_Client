import UIKit

class GridViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - Properties
    let rectangleBox = UIView()
    var gridColumns: Int
    var gridRows: Int
    var boxes: [Bool]
    let buttonOne = UIButton(type: .system)
    let buttonTwo = UIButton(type: .system)
    var collectionView: UICollectionView!

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
        view.backgroundColor = .systemBackground
        setupRectangleBox()
        setupCollectionView()

        if gridColumns % 2 == 0 {
            setupButtons()
        }
        setupConstraints()

    }

    private func setupRectangleBox() {
        rectangleBox.backgroundColor = .red
        rectangleBox.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rectangleBox)
    }

    private func setupButtons() {
        configureButton(buttonOne, title: "One")
        configureButton(buttonTwo, title: "Two")
    }

    private func configureButton(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        
        // Calculate dynamic spacing based on the number of columns
        let baseSpacing = 5
        let spacingIncrement = 10
        let columnDifference = max(0, 8 - gridColumns)
        layout.minimumInteritemSpacing = CGFloat(baseSpacing + spacingIncrement * columnDifference)
        layout.minimumLineSpacing = 2

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
    }

    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        let cellSize: CGFloat = 30
        let spacing: CGFloat = 2 // Base spacing for layout
        let dynamicSpacing = calculateDynamicSpacing(columns: gridColumns)
        let totalCellWidth = (cellSize * CGFloat(gridColumns)) + (dynamicSpacing * CGFloat(gridColumns - 1))
        let totalCellHeight = (cellSize * CGFloat(gridRows)) + (spacing * CGFloat(gridRows - 1))

        NSLayoutConstraint.activate([
            rectangleBox.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * (3.5 / 7.0)),
            rectangleBox.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rectangleBox.widthAnchor.constraint(equalToConstant: 100),
            rectangleBox.heightAnchor.constraint(equalToConstant: 30),
            
            collectionView.heightAnchor.constraint(equalToConstant: totalCellHeight),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.widthAnchor.constraint(equalToConstant: totalCellWidth),
            collectionView.bottomAnchor.constraint(equalTo: rectangleBox.topAnchor, constant: -20),
        ])
        if gridColumns % 2 == 0 {
            // Set up constraints for the buttons only if they are added to the view
            NSLayoutConstraint.activate([
                buttonOne.topAnchor.constraint(equalTo: rectangleBox.bottomAnchor, constant: 20),
                buttonOne.leadingAnchor.constraint(equalTo: rectangleBox.leadingAnchor),
                
                buttonTwo.topAnchor.constraint(equalTo: rectangleBox.bottomAnchor, constant: 20),
                buttonTwo.trailingAnchor.constraint(equalTo: rectangleBox.trailingAnchor)
            ])
        }
    }
    
    private func calculateDynamicSpacing(columns: Int) -> CGFloat {
        let baseSpacing = 5
        let spacingIncrement = 10
        let columnDifference = max(0, 8 - columns)
        return CGFloat(baseSpacing + spacingIncrement * columnDifference)
    }


    // UICollectionViewDataSource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gridRows * gridColumns
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.blue // All cells are highlighted
        return cell
    }

    // UICollectionViewDelegateFlowLayout methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 30)
    }

}
