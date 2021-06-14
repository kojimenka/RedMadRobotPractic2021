//
//  CreatePostContainerVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 12.06.2021.
//

import UIKit

/// Контейнер для создания постов
final class CreatePostContainerVC: UIViewController {
    
    // MARK: - Private Properties
    
    private let feedService: FeedService
    
    private let loaderVC = LoaderVC()
    
    /// Модель данных для нового поста
    private var addPostModel = AddPostModel()
    
    /// Валидатор для текста постав
    private var postValidator: Validator
    
    /// Менеджер хранящий данные, каким экраном нужно обновить данные
    private var updateManager: UpdateManager
    
    // Chilf
    
    lazy private var createPostVC = CreatePostVC(delegate: self)
    
    // MARK: - Init
    
    init(
        updateManager: UpdateManager = ServiceLayer.shared.updateManager,
        feedService: FeedService = ServiceLayer.shared.feedService,
        postValidator: Validator = TextOnPostValidatorValidator()
    ) {
        self.updateManager = updateManager
        self.feedService = feedService
        self.postValidator = postValidator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setChilds()
    }
    
    // MARK: - Private Methods
    
    private func setChilds() {
        addChild(controller: createPostVC, rootView: view)
    }

}

// MARK: - CreatePostVC Delegate

extension CreatePostContainerVC: CreatePostVCDelegate {
    
    func currentPostText(_ text: String?) {
        addPostModel.text = text
    }
    
    func removePhoto() {
        addPostModel.imageData = nil
    }
    
    func sendPost() {
        do {
            _ = try postValidator.isValid(value: addPostModel.text ?? "")
        } catch let error {
            self.showAlert(alertText: error.localizedDescription)
            return
        }
        
        presentLoader()
        
        _ = feedService.addPost(postInfo: addPostModel) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.updateManager.isUpdateUserPostNeeded = true
                self.updateManager.isUpdateFeedNeeded = true
                self.loaderVC.dismiss(animated: true) {
                    self.showSuccessPostAlert()
                }
            case .failure:
                self.loaderVC.dismiss(animated: true) {
                    self.showFailurePostAlert()
                }
            }
        }
    }
    
    func showMapScreen() {
        let mapVC = SetGeopositionVC(delegate: self)
        mapVC.modalPresentationStyle = .fullScreen
        self.present(mapVC, animated: true)
    }
    
    func showGallery() {
        presentImagePicker()
    }
    
    func presentLoader() {
        loaderVC.modalPresentationStyle = .overFullScreen
        loaderVC.modalTransitionStyle = .crossDissolve
        
        loaderVC.stopLoad = { [weak self] in
            guard let self = self else { return }
            self.loaderVC.dismiss(animated: true)
        }
        
        self.present(loaderVC, animated: true)
    }
    
    func showSuccessPostAlert() {
        let alert = UIAlertController.createAlert(
            alertText: "Пост успешно создан") { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
        
        self.present(alert, animated: true)
    }
    
    func showFailurePostAlert() {
        let alert = UIAlertController.createAlert(alertText: "Ошибка создания поста")
        self.present(alert, animated: true)
    }

}

// MARK: - Map Screen Delegate

extension CreatePostContainerVC: SetGeopositionVCDelegate {
    
    func userSetCoordinates(_ coordinated: Coordinates) {
        addPostModel.lon = coordinated.longitude
        addPostModel.lat = coordinated.latitude
    }
    
}

// MARK: - ImagePicker Delegate

extension CreatePostContainerVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    private func presentImagePicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {

        picker.dismiss(animated: true)

        guard let image = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }
        
        addPostModel.imageData = image.jpegData(compressionQuality: 50)
        createPostVC.changePhoto(image: image)
    }
    
}
