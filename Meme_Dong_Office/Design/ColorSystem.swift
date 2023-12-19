import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        assert(alpha >= 0.0 && alpha <= 1.0, "Invalid alpha component") // Allow alpha to be 1.0
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }

    convenience init(rgb: Int, alpha: CGFloat) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            alpha: alpha
        )
    }

    // MARK: - 디자인 시스템 컬러 지정
    static var background: UIColor {
        return UIColor(rgb: 0xffF4F1EF, alpha: 1.0)
    }

    static var primary: UIColor {
        return UIColor(rgb: 0xffF35E3E, alpha: 1.0)
    }

    static var secondary: UIColor {
        return UIColor(rgb: 0xff239F95, alpha: 1.0)
    }

    static var textBlack: UIColor {
        return UIColor(rgb: 0xff2B2B2B, alpha: 1.0)
    }
}
