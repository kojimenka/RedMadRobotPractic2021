//
//  AuthorizationTextField.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 19.04.2021.
//

import UIKit

enum KeyboardAction {
    case showKeyboard(keyboardHeight: CGFloat)
    case hideKeyboard
}

final class NewAuthorizationTextField: UITextFieldWithInset {
    
    // MARK: - Private Properties
    
    private var isFirstDraw = true
    
    private let bottomLine: CALayer = {
        let layer = CALayer()
        layer.cornerRadius = 1.0
        layer.masksToBounds = true
        layer.backgroundColor = ColorPalette.notActive.cgColor
        return layer
    }()
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 48)
    }
    
    // MARK: - UIView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard isFirstDraw == true else { return }
        setupBottomLine()
        isFirstDraw = false
    }
    
    // MARK: - Private Methods
    
    private func initialSetup() {
        setupTargets()
        setupTextField()
    }
    
    private func setupTargets() {
        addTarget(self, action: #selector(setEditColor), for: .editingDidBegin)
    }
    
    public func isValidFill(_ isValid: Bool) {
        let neededColor = !isValid ? ColorPalette.tintOrangeColor : ColorPalette.notActive
        bottomLine.backgroundColor = neededColor.cgColor
        if !isValid {
            self.shakeView()
        }
    }
    
    @objc private func setEditColor() {
        let neededColor = ColorPalette.notActive
        bottomLine.backgroundColor = neededColor.cgColor
    }
    
    private func setupTextField() {
        super.textInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        borderStyle = .none
        font = R.font.ibmPlexSans(size: 14)
        tintColor = .black
        autocorrectionType = .no
    }
    
    private func setupBottomLine() {
        bottomLine.frame = CGRect(
            x: 0,
            y: self.frame.size.height - 2,
            width: self.frame.size.width,
            height: 2
        )
        layer.addSublayer(bottomLine)
    }
    
}

class UITextFieldWithInset: UITextField {
    
    public var textInsets = UIEdgeInsets.zero {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
}
