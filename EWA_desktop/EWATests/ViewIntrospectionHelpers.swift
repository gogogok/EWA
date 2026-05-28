import UIKit

extension UIView {
    func allSubviewsRecursive<T: UIView>(of type: T.Type) -> [T] {
        var result: [T] = []
        for subview in subviews {
            if let match = subview as? T {
                result.append(match)
            }
            result.append(contentsOf: subview.allSubviewsRecursive(of: type))
        }
        return result
    }

    func firstButton(withTitle title: String) -> UIButton? {
        allSubviewsRecursive(of: UIButton.self).first { $0.title(for: .normal) == title }
    }

    func containsLabelText(_ text: String) -> Bool {
        allSubviewsRecursive(of: UILabel.self).contains { $0.text == text }
    }
}
