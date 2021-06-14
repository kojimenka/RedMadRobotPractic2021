//
//  CreatePostVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 12.06.2021.
//

import UIKit

protocol CreatePostVCDelegate: AnyObject {
    func showMapScreen()
    func showGallery()
    func sendPost()
    func removePhoto()
    func currentPostText(_ text: String?)
}

/// Экран ответственный за заполнение поста
final class CreatePostVC: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var actionsStackView: UIStackView!
    @IBOutlet private weak var contentScrollView: UIScrollView!
    @IBOutlet private weak var contentStackView: UIStackView!
    @IBOutlet private weak var postTextView: UITextView!
    @IBOutlet private weak var actionsStackViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var navigationBar: UINavigationBar!
    
    @IBOutlet private weak var postImageView: UIImageView!
    @IBOutlet private weak var postImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var deletePhotoButton: UIButton!
    
    // MARK: - Private Methods
    
    weak private var delegate: CreatePostVCDelegate?
    
    /// ViewModel для отслеживания клавиатуры
    private let checkKeyboardViewModel: CheckKeyboardViewModel
    
    /// Прозрачная вьюха которая имеет размер клавиутуру, она нужна чтобы пользователь мог скролить содержания поста когда клавиатура поднята
    private var emptyKeyboardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var emptyKeyboardViewHeightConstraint = NSLayoutConstraint()
    
    // MARK: - Init
    
    init(
        delegate: CreatePostVCDelegate?,
        checkKeyboardViewModel: CheckKeyboardViewModel = CheckKeyboardViewModel()
    ) {
        self.delegate = delegate
        self.checkKeyboardViewModel = checkKeyboardViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - IBActions
    
    @IBAction private func geoPositionButtonAction(_ sender: Any) {
        delegate?.showMapScreen()
    }
    
    @IBAction private func addPhotoButtonAction(_ sender: Any) {
        delegate?.showGallery()
    }
    
    @IBAction private func sendPostButtonAction(_ sender: Any) {
        delegate?.sendPost()
    }
    
    @IBAction private func removePhoto(_ sender: Any) {
        delegate?.removePhoto()
        UIView.animate(withDuration: 0.3) {
            self.postImageView.alpha = 0.0
            self.deletePhotoButton.alpha = 0.0
            self.postImageView.isHidden = true
        } completion: { _ in
            self.postImageView.image = nil
        }
    }
    
    // MARK: - Public Methods
    
    public func changePhoto(image: UIImage) {
        /// Считаем соотношение сторон фотографии
        let imageAspectRatio = image.size.height / image.size.width
        
        /// Ширина фотографии равна ширине scrollView
        let width = contentScrollView.frame.width
        
        /// Рассчитываем высоту картинки основываясь на ширине и соотношение сторон
        let height = width * imageAspectRatio
        
        postImageView.image = image
        postImageViewHeightConstraint.constant = height
        postImageView.isHidden = false
        
        UIView.animate(withDuration: 0.3) {
            self.postImageView.alpha = 1.0
            self.deletePhotoButton.alpha = 1.0
        }
        
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        /// Настраиваем пустую вьюху для клавиатуры
        emptyKeyboardViewHeightConstraint = emptyKeyboardView.heightAnchor.constraint(equalToConstant: 0)
        emptyKeyboardViewHeightConstraint.isActive = true
        
        /// Настраиваем ViewModel для отслеживания клавиатуры
        checkKeyboardViewModel.delegate = self
        self.hideKeyboardWhenTappedAround()
        
        view.bringSubviewToFront(actionsStackView)
        contentStackView.addArrangedSubview(emptyKeyboardView)
        
        setupNavBar()
    }
    
    /// Настраиваем NavBar
    private func setupNavBar() {
        let play = UIBarButtonItem(
            image: R.image.removeFriendIcon(),
            style: .plain,
            target: self,
            action: #selector(closeButtonAction)
        )
        
        let navigationItem = UINavigationItem()
        navigationItem.rightBarButtonItem = play
        navigationItem.title = "Пост"
        
        navigationBar.tintColor = .black
        navigationBar.setItems([navigationItem], animated: false)
    }
    
    @objc private func closeButtonAction() {
        self.dismiss(animated: true)
    }
    
}

// MARK: - Check Keyboard

extension CreatePostVC: CheckKeyboardViewModelDelegate {
    
    func keyboardAction(action: KeyboardAction) {
        switch action {
        case .hideKeyboard:
            actionsStackViewBottomConstraint.constant = 20
            emptyKeyboardViewHeightConstraint.constant = 0
        case .showKeyboard(keyboardHeight: let height):
            actionsStackViewBottomConstraint.constant = height + 10
            emptyKeyboardViewHeightConstraint.constant = height + 10
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
}

// MARK: - UITextView Delegate

extension CreatePostVC: UITextViewDelegate {
    
    /// Только так правильно работает установка tint color в textView
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        let color = textView.tintColor
        textView.tintColor = .clear
        textView.tintColor = color
        
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    /// Эмуляция PlaceHolder-a
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Чем хотите поделиться?"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            delegate?.currentPostText(nil)
        } else {
            delegate?.currentPostText(textView.text)
        }
    }
    
}
