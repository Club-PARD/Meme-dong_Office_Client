import UIKit

class CustomGridLayout: UICollectionViewFlowLayout {
            
    var gridColumns: Int
    var cellSize: CGSize
    var baseHeight: CGFloat
    var useAlternatingSpacing: Bool = false
    var baseSpacing: CGFloat

    init(columns: Int) {
        self.gridColumns = columns
        self.baseSpacing = 15 + ((8 - CGFloat(gridColumns)) * 10)
        self.baseHeight = 2
        self.cellSize = CGSize(width: 30, height: 25)
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        let spacenum = CGFloat(gridColumns) - 1
        let totalCellWidth = (CGFloat(cellSize.width) * CGFloat(gridColumns)) + (baseSpacing * spacenum)
        let dynamicSpacing = calculateDynamicSpacingOdd(totalWidth: totalCellWidth, columns: gridColumns, cellsize: cellSize.width)

        self.minimumInteritemSpacing = dynamicSpacing
        self.minimumLineSpacing = baseHeight
        self.itemSize = CGSize(width: cellSize.width, height: cellSize.height)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)?.map { $0.copy() as! UICollectionViewLayoutAttributes }
        
        let totalCellWidth = (cellSize.width * CGFloat(gridColumns)) + (baseSpacing * (CGFloat(gridColumns) - 1))
        // Calculate dynamic spacing based on the current state of the collection view
        let dynamicSpacingEven = calculateDynamicSpacingEven(totalWidth: totalCellWidth, columns: gridColumns, cellsize: cellSize.width)
        
            if gridColumns % 2 == 0 && useAlternatingSpacing {
                var xOffset: CGFloat = 0
                var previousRow: Int = 0
                
                // Define spacing constants
                let smallSpace: CGFloat = 2  // smaller space between cells
                let largeSpace: CGFloat = dynamicSpacingEven // larger space between cells
//                let largeSpace: CGFloat = 70 // larger space between cells

                attributes?.forEach { layoutAttribute in
                    let indexPath = layoutAttribute.indexPath
                    let columnIndex = indexPath.item % gridColumns
                    let rowIndex = indexPath.item / gridColumns
                    
                    if rowIndex != previousRow {
                        xOffset = 0 // Reset xOffset for each new row
                        previousRow = rowIndex
                    }
                    
                    layoutAttribute.frame.origin.x = xOffset
                    
                    // Alternating space logic
                    if columnIndex % 2 == 0 {
                        xOffset += itemSize.width + smallSpace
                    } else {
                        xOffset += itemSize.width + largeSpace
                    }
                }
            } else {
                self.minimumInteritemSpacing = self.baseSpacing
                self.minimumLineSpacing = 2
            }
            
            return attributes
        }
        
    

    func calculateDynamicSpacingOdd(totalWidth: CGFloat, columns: Int, cellsize: CGFloat) -> CGFloat {
        guard columns > 1 else {
            return 0
        }
        
        let totalSpacing = totalWidth - (cellsize * CGFloat(columns))
        return totalSpacing / CGFloat(columns - 1)
    }
    
    func calculateDynamicSpacingEven(totalWidth: CGFloat, columns: Int, cellsize: CGFloat) -> CGFloat {
        guard columns > 2 else {
            return 0 // Return 0 for single column
        }
        
        // Calculate the number of larger gaps
        let numberOfLargerGaps = CGFloat(columns / 2) - 1
        
        // Calculate the total width taken by cells
        let totalCellWidth = cellsize * CGFloat(columns)
        
        // Calculate the total width taken by smaller gaps (fixed at 2 points each)
        let totalSmallSpacing = (CGFloat(columns - 1) - numberOfLargerGaps) * 2
        
        // Calculate the remaining width available for larger gaps
        let remainingWidthForLargeSpacing = totalWidth - totalCellWidth - totalSmallSpacing
        
        // Divide the remaining width by the number of larger gaps to find the spacing for larger gaps
        return (remainingWidthForLargeSpacing / numberOfLargerGaps)
    }
}


